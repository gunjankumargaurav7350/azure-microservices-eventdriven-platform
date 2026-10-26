"""
Order Microservice API with Dapr Event Publishing
Author: Gunjan Kumar Gaurav (Senior Cloud Architect)
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests
import os
import uuid
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("OrderService")

app = FastAPI(title="Enterprise Order Service", version="1.0.0")

DAPR_HTTP_PORT = os.getenv("DAPR_HTTP_PORT", "3500")
PUBSUB_NAME = "pubsub-servicebus"
TOPIC_NAME = "orders.v1"

class OrderRequest(BaseModel):
    customer_id: str
    amount_usd: float
    items: list[str]

@app.post("/v1/orders", status_code=201)
def create_order(order: OrderRequest):
    order_id = str(uuid.uuid4())
    event_payload = {
        "order_id": order_id,
        "customer_id": order.customer_id,
        "amount_usd": order.amount_usd,
        "items": order.items,
        "status": "PENDING_PAYMENT"
    }

    # Publish message asynchronously through Dapr sidecar to Azure Service Bus
    dapr_url = f"http://localhost:{DAPR_HTTP_PORT}/v1.0/publish/{PUBSUB_NAME}/{TOPIC_NAME}"
    try:
        resp = requests.post(dapr_url, json=event_payload, timeout=5)
        logger.info(f"Published order event {order_id} via Dapr sidecar (Status: {resp.status_code})")
        return {"order_id": order_id, "status": "QUEUED"}
    except Exception as e:
        logger.error(f"Failed to publish event via Dapr: {e}")
        return {"order_id": order_id, "status": "QUEUED_LOCAL_FALLBACK"}
