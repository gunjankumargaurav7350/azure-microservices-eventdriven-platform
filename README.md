# Azure Microservices Event-Driven Platform

An asynchronous microservices architecture built on Azure Container Apps, Dapr runtime, and Azure Service Bus.

```
[ Client Traffic (HTTP/REST) ]
              |
              v
[ Order Service (FastAPI Container App) ]
              |
              v  (Dapr Sidecar HTTP/gRPC)
[ Azure Service Bus Topic: orders.v1 ]
              |
      +-------+-------+
      |               |
      v               v
[ Payment Worker ]  [ Inventory Worker ]
```

## Features

- **Decoupled Messaging:** Asynchronous pub/sub via Azure Service Bus using Dapr sidecars.
- **Auto-Scaling:** Serverless scale-to-zero compute with KEDA scaling on queue depth.
- **Security-First Container:** Multi-stage non-root Docker build with health probes.
- **IaC with Terraform:** Modular infrastructure with dynamic `for_each` resource definition.
- **CI/CD:** Automated testing, linting, container builds, and Trivy security scanning.

## Repository Layout

```
azure-microservices-eventdriven-platform/
├── .github/workflows/
│   ├── order-service-ci.yml              # Python lint, test, docker build & Trivy scan
│   └── terraform-ci-cd.yml               # Terraform fmt, init & validate
├── azure-pipelines.yml                   # Azure DevOps pipeline
├── dapr-components/
│   └── pubsub-servicebus.yaml            # Dapr pub/sub binding
├── services/
│   └── order-service/                    # FastAPI order service
│       ├── Dockerfile                    # Multi-stage non-root build
│       ├── order_api.py                  # API endpoints & Dapr publisher
│       ├── requirements.txt              # Dependencies
│       └── tests/                        # Unit tests
└── terraform/                            # Modular infrastructure
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── modules/
        ├── container_apps_environment/
        └── service_bus/
```

## Running the Order Service Locally

### 1. Run with Python

```bash
cd services/order-service
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn order_api:app --reload --port 8000
```

Endpoints available:
- `GET /healthz` - Liveness probe
- `GET /ready` - Readiness probe
- `POST /v1/orders` - Create order
- `GET /v1/orders` - List orders
- `GET /v1/orders/{order_id}` - Get order by ID
- `GET /docs` - Swagger UI

### 2. Run with Docker

```bash
docker build -t order-service:latest services/order-service
docker run -p 8000:8000 order-service:latest
```

## Deploying Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Author

**Gunjan Kumar Gaurav**  
*Senior Cloud & DevSecOps Consultant*  
[LinkedIn](https://www.linkedin.com/in/gunjan-gaurav) • [GitHub](https://github.com/gunjankumargaurav7350)
