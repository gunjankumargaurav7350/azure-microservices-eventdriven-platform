import os
import uuid
import logging
from typing import Dict, List, Optional
from datetime import datetime, timezone
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field
import httpx

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger("order-service")

DAPR_HTTP_PORT = os.getenv("DAPR_HTTP_PORT", "3500")
PUBSUB_NAME = os.getenv("PUBSUB_NAME", "pubsub-servicebus")
TOPIC_NAME = os.getenv("TOPIC_NAME", "orders.v1")

# In-memory store for orders state
orders_db: Dict[str, dict] = {}
http_client: Optional[httpx.AsyncClient] = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    global http_client
    http_client = httpx.AsyncClient(timeout=5.0)
    logger.info("Order service started. Dapr port: %s", DAPR_HTTP_PORT)
    yield
    await http_client.aclose()
    logger.info("Order service shut down.")


app = FastAPI(
    title="Order Processing Service",
    description="Event-driven order service with Dapr and Azure Service Bus",
    version="1.0.0",
    lifespan=lifespan,
)


class OrderCreate(BaseModel):
    customer_id: str = Field(..., min_length=3, max_length=64, example="cust-1024")
    amount_usd: float = Field(..., gt=0, example=149.99)
    items: List[str] = Field(..., min_items=1, example=["laptop-stand", "usb-c-cable"])


class OrderResponse(BaseModel):
    order_id: str
    customer_id: str
    amount_usd: float
    items: List[str]
    status: str
    created_at: str


@app.get("/healthz", status_code=status.HTTP_200_OK)
async def health_check():
    return {"status": "healthy", "service": "order-service"}


@app.get("/ready", status_code=status.HTTP_200_OK)
async def readiness_check():
    return {"status": "ready"}


@app.post("/v1/orders", response_model=OrderResponse, status_code=status.HTTP_201_CREATED)
async def create_order(payload: OrderCreate):
    order_id = str(uuid.uuid4())
    timestamp = datetime.now(timezone.utc).isoformat()

    order_record = {
        "order_id": order_id,
        "customer_id": payload.customer_id,
        "amount_usd": payload.amount_usd,
        "items": payload.items,
        "status": "PENDING_PAYMENT",
        "created_at": timestamp,
    }

    orders_db[order_id] = order_record

    # Publish message through Dapr sidecar to Azure Service Bus topic
    dapr_url = f"http://localhost:{DAPR_HTTP_PORT}/v1.0/publish/{PUBSUB_NAME}/{TOPIC_NAME}"
    published = False

    if http_client:
        try:
            resp = await http_client.post(dapr_url, json=order_record)
            if resp.status_code in (200, 204):
                published = True
                logger.info("Published order event %s to topic %s", order_id, TOPIC_NAME)
        except Exception as err:
            logger.warning("Dapr sidecar not available (%s). Order queued locally.", err)

    if not published:
        order_record["status"] = "QUEUED_LOCAL"

    return order_record


@app.get("/v1/orders/{order_id}", response_model=OrderResponse)
async def get_order(order_id: str):
    if order_id not in orders_db:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Order not found")
    return orders_db[order_id]


@app.get("/v1/orders", response_model=List[OrderResponse])
async def list_orders(limit: int = 50):
    records = list(orders_db.values())[-limit:]
    return records
