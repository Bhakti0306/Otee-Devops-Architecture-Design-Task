variable "aws_region" {
  type        = string
  description = "AWS region (e.g., eu-north-1)"
  default     = "eu-north-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = "otee"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
  default     = "dev"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}