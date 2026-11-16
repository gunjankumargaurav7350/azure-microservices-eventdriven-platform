import pytest
from httpx import AsyncClient, ASGITransport
import sys
import os

# Add parent directory to path so order_api can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from order_api import app


@pytest.mark.asyncio
async def test_health_check():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.get("/healthz")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert data["service"] == "order-service"


@pytest.mark.asyncio
async def test_readiness_check():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.get("/ready")
        assert response.status_code == 200
        assert response.json()["status"] == "ready"


@pytest.mark.asyncio
async def test_create_order_success():
    payload = {
        "customer_id": "cust-test-101",
        "amount_usd": 89.50,
        "items": ["keyboard", "mousepad"]
    }
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.post("/v1/orders", json=payload)
        assert response.status_code == 201
        data = response.json()
        assert "order_id" in data
        assert data["customer_id"] == "cust-test-101"
        assert data["amount_usd"] == 89.50
        assert len(data["items"]) == 2


@pytest.mark.asyncio
async def test_create_order_invalid_payload():
    invalid_payload = {
        "customer_id": "c",  # too short
        "amount_usd": -10,   # must be > 0
        "items": []          # min 1 item
    }
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.post("/v1/orders", json=invalid_payload)
        assert response.status_code == 422


@pytest.mark.asyncio
async def test_get_order_not_found():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.get("/v1/orders/non-existent-order-id")
        assert response.status_code == 404
