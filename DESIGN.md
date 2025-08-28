# Otee IoT Architecture – Focused Design

## 📌 Architecture Flow Diagram
The full IoT ingestion and processing architecture is designed in Figma:  
👉 [View Diagram Here](https://www.figma.com/make/dLdp58bJ8iaAWDIIbQTvvl/IoT-Architecture-Flow-Diagram?fullscreen=1)

This diagram highlights:
- **Data ingestion flow** from PLC devices to storage and downstream consumers.
- **Network security boundaries** (VPC, private subnets, security groups).
- **Relevant AWS services** used in the ingestion pipeline.

---

## 📊 Data Flow (PLC → Storage)

1. **PLC Devices**  
   - Connect securely using **MQTT/TLS with X.509 certificates**.
   - Messages published to AWS IoT Core.

2. **AWS IoT Core**  
   - Acts as the device gateway (authentication + topic routing).
   - Rules forward data into **Kinesis Data Streams**.

3. **Kinesis Data Streams**  
   - Handles high-throughput ingestion with auto-scaling shards.
   - Provides real-time feed to **Lambda functions** for anomaly detection.

4. **AWS Lambda**  
   - Processes events in real-time.
   - Example: If `temperature > 100°C`, publish alert to **SNS**.
   - Writes transformed data into DynamoDB.

5. **Amazon DynamoDB / Amazon S3**  
   - DynamoDB for **low-latency MES queries**.  
   - S3 for **raw event storage & analytics**.

6. **Amazon API Gateway**  
   - Secure API layer for MES to query processed data.

---

## 🔒 Network Security Boundaries
- All services are deployed in **EU region VPC**.  
- **IoT Core → Kinesis → Lambda** interactions restricted via **IAM least-privilege roles**.  
- **Security Groups** restrict traffic flow (ingestion layer only allows necessary ports).  
- **Private subnets** for Kinesis, Lambda, DynamoDB access (no direct internet).  
- **Encryption** enabled at rest (KMS) and in transit (TLS).  

---

## 🧩 Relevant AWS Services
- **AWS IoT Core** – Device connectivity (MQTT/TLS).  
- **Amazon Kinesis Data Streams** – Real-time ingestion.  
- **AWS Lambda** – Anomaly detection + transformation.  
- **Amazon DynamoDB** – Fast MES lookups.  
- **Amazon S3** – Long-term data storage.  
- **Amazon API Gateway** – Secure MES integration.  
- **Amazon SNS** – Real-time alerts.  
- **Amazon CloudWatch** – Monitoring, logging, metrics.  

---

## ✅ Notes
- Design favors **serverless-first** → no EC2.  
- Optimized for **99.9% uptime** with managed AWS services.  
- Scales automatically (IoT → Kinesis shards → Lambda concurrency).  

