# Otee Pipeline Documentation

This directory contains architectural decisions, implementation plans, and scaling strategies for the Otee AWS-based industrial data ingestion pipeline.

## Structure

- **decisions/**  
  Contains key decision records and implementation details:
  - **Implementation Plan**: Step-by-step AWS provisioning and integration.
  - **otee-aws-ingestion.md**: Rationale and architecture overview.
  - **Scaling-approach**: How the solution scales with device and data growth.
  - **Trade-off Decisions**: Alternatives considered and reasoning.

  - **terraform/**  
  Contains the Terraform configuration files for provisioning the core ingestion pipeline:
  - **Core Ingestion Components**: S3 bucket, DynamoDB table, Kinesis stream, and SNS topic.
  - **Security Configurations**: IAM policies with least-privilege access, S3 encryption, and public access block.
  - **Infrastructure as Code**: Simplified `main.tf` and `variables.tf` for managing resources.


- **Design Link**: [IoT Architecture Flow Diagram](https://www.figma.com/make/dLdp58bJ8iaAWDIIbQTvvl/IoT-Architecture-Flow-Diagram?fullscreen=1)