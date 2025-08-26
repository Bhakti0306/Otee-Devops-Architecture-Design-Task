# Trade-off Decisions

## IoT Core vs Direct S3

- **Chosen:** IoT Core for secure, real-time data streaming.
- **Alternative:** Direct S3 ingestion via API Gateway (simpler but lacks real-time guarantees).

## Serverless vs EC2

- **Chosen:** Serverless to reduce cost and operational overhead.
- **Trade-off:** Cold-start latency on Lambdas (acceptable for alerts).

## Storage Choice (S3 + DynamoDB)

- **Chosen:** Combination of S3 and DynamoDB to balance cost and performance.
- **Trade-off:** Requires maintaining sync pipelines