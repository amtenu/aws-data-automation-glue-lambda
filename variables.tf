variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "ca-west-1"
}

variable "s3_bucket_name" {
  description = "Globally unique name for the S3 data lake bucket"
  type        = string
}

variable "project_name" {
  description = "Short name used to prefix all resources"
  type        = string
  default     = "aws-data-automation"
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "dev"
}
variable "alert_email" {
  description = "Email address to receive pipeline/alarm alerts"
  type        = string
}
