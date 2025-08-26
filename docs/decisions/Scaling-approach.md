# Scaling Approach

- **IoT Core**: Handles thousands of devices natively; current load (~200 PLCs) is well within limits.
- **Kinesis Data Streams**: Auto-scales by adding shards during traffic spikes.
- **DynamoDB**: On-demand capacity for unpredictable MES queries.
- **Lambda**: Scales horizontally with event load.
- **S3**: Virtually infinite storage.

## Future-proofing

- If device count grows: Use IoT Device Defender for fleet security.
- If analytics needed: Integrate Kinesis → Firehose → Redshift