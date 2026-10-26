# ⚡ Azure Microservices Event-Driven Platform (Dapr + Service Bus + Container Apps)

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Azure Container Apps](https://img.shields.io/badge/Compute-Azure_Container_Apps-0078D4.svg?logo=microsoftazure)](https://azure.microsoft.com)
[![Dapr](https://img.shields.io/badge/Distributed_Runtime-Dapr_1.13-4B82F0.svg?logo=dapr)](https://dapr.io/)
[![Azure Service Bus](https://img.shields.io/badge/Messaging-Azure_Service_Bus-blue.svg)](https://azure.microsoft.com)
[![Python](https://img.shields.io/badge/Language-Python_FastAPI-3776AB.svg?logo=python)](https://fastapi.tiangolo.com)

**Enterprise Asynchronous Microservices Fabric • Distributed Application Runtime (Dapr) • Service Bus Pub/Sub • Zero-Locking Cosmos DB State Store**

[Architecture](#-architecture) • [Dapr Integration](#-dapr-distributed-building-blocks) • [Service Flow](#-event-driven-messaging-flow) • [Deployment](#-deployment)

</div>

---

## 🎯 Executive Overview

Modern microservices architectures require loose coupling, resilience against cascading failures, and high-throughput asynchronous communication. **Azure Microservices Event-Driven Platform** was designed and implemented by **Gunjan Kumar Gaurav** utilizing **Azure Container Apps** and **Dapr (Distributed Application Runtime)**.

```
[ Client Traffic (HTTP/REST) ]
              |
              v
[ Order Microservice (Container App) ]
              |
              v  (Dapr Sidecar HTTP/gRPC)
[ Azure Service Bus Topic: orders.v1 ]
              |
      +-------+-------+
      |               |
      v               v
[ Payment Worker ]  [ Inventory Sync Worker ]
      |               |
      v               v
[ Cosmos DB State ] [ Redis Cache Cluster ]
```

---

## ⚡ Key Capabilities

* **Dapr Sidecar Architecture:** Decouples microservices from vendor-specific SDKs. Service invocation, pub/sub, state management, and secrets are handled via local Dapr sidecars.
* **Elastic Serverless Scaling (KEDA):** Container Apps automatically scale from 0 to 100+ replicas based on Azure Service Bus topic queue depth.
* **Distributed Tracing (W3C Trace Context):** End-to-end request tracing aggregated into Azure Application Insights without invasive manual code instrumentation.

---

## 📁 Repository Structure

```
azure-microservices-eventdriven-platform/
├── dapr-components/
│   ├── pubsub-servicebus.yaml            # Dapr Service Bus Topic binding
│   └── statestore-cosmos.yaml            # Distributed state store configuration
├── services/
│   ├── order-service/                    # Producer REST API microservice
│   └── payment-processor/                # Consumer background worker
├── terraform/
│   ├── container_apps.tf                 # Container Apps Environment & Service Bus
│   ├── variables.tf
│   └── outputs.tf
└── README.md
```

---

## 👤 Architect & Author

**Gunjan Kumar Gaurav**  
*Senior Cloud Architect & DevSecOps Consultant*  
[LinkedIn](https://www.linkedin.com/in/gunjan-gaurav) • [GitHub](https://github.com/gunjankumargaurav7350) • Email: `gunjankumargaurav7@gmail.com`
