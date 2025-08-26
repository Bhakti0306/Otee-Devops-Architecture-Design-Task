# Implementation Plan

1. **Provision IoT Core**  
   - Deploy in EU region VPC  
   - Configure device registry and policies

2. **Connect PLCs**  
   - Use MQTT over TLS  
   - Assign unique certificates to each device

3. **IoT Rule Setup**  
   - Route device data to Kinesis Data Stream (real-time ingestion)

4. **Data Persistence**  
   - Store raw data in S3  
   - Index data in DynamoDB

5. **Stream Processing**  
   - Configure Lambda to process Kinesis stream  
   - If temperature > 100°C, trigger SNS alert

6. **MES Query API**  
   - Deploy API Gateway with Lambda backend  
   - Enable read access to DynamoDB and S3

7. **Monitoring & Uptime**  
   - Enable CloudWatch dashboards, alarms, and logs  
   - Target 99.9% uptime