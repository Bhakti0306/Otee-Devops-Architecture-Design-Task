## Context

Otee needs to securely collect data from about 200 PLC devices and send it to AWS in real time. The data will be used for detecting problems early and for running MES (manufacturing system) queries.  
The solution should have:

- **Strong device authentication:** Only trusted devices can send data.
- **Low maintenance effort:** Easy to manage at scale.
- **Real-time data handling:** Minimal delay from device to AWS.
- **High availability:** 99.9% uptime.
- **Cost efficiency:** Optimized for spend.

---

### Decision Explanation

Combination of the following AWS services to keep things secure, simple, and cost-effective:

1. **AWS IoT Core** – Secure front gate. Each PLC shows its ID card before it can send data.
2. **Kinesis Data Streams** – Once inside, the data goes onto a moving belt that carries it in real time without delays.
3. **Lambda Functions** – Small programs stand along the belt. They quickly check if the data looks normal or if something strange is happening (anomaly detection).
4. **Amazon S3** (Cold path) – All the raw data is stored here for long-term retention, analytics, and cost efficiency.
5. **DynamoDB** (Hot path) – Key information is saved here in an organized way, so it’s easy and fast to look up later (latest values, low latency, quick queries).
6. **API Gateway + Lambda** – A help desk window. The MES system can come and ask questions and the API gives back the right answers.

---

#### Two workflows MES can follow:

- **MES → API Gateway → Lambda → DynamoDB**  
  - *Query:* “Give me last 15 minutes of readings for Site A, Line 3.”  
  - *Response:* Assembled by Lambda with DynamoDB query.

- **MES → API Gateway → Lambda → IoT Core**  
  - *Command:* “Reset PLC X”  
  - *Flow:* Lambda publishes MQTT message to IoT Core → delivered to device via IoT Jobs.

---

## Conclusion

This setup keeps devices secure, handles data in real time, and makes sure we can store everything safely while still giving quick answers when the MES needs them.
