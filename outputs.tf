output "s3_bucket_name" {
  description = "Data lake S3 bucket name"
  value       = aws_s3_bucket.data_lake.bucket
}

output "s3_bucket_arn" {
  description = "Data lake S3 bucket ARN"
  value       = aws_s3_bucket.data_lake.arn
}

output "glue_role_arn" {
  description = "ARN of the Glue IAM service role"
  value       = aws_iam_role.glue_role.arn
}

output "glue_catalog_database" {
  description = "Name of the Glue Data Catalog database"
  value       = aws_glue_catalog_database.main.name
}

output "glue_crawler_name" {
  description = "Name of the Glue Crawler"
  value       = aws_glue_crawler.main.name
}

output "athena_workgroup" {
  description = "Name of the Athena workgroup"
  value       = aws_athena_workgroup.main.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS alerts topic"
  value       = aws_sns_topic.pipeline_alerts.arn
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log group names"
  value = {
    glue_crawler = aws_cloudwatch_log_group.glue_crawler.name
    glue_jobs    = aws_cloudwatch_log_group.glue_jobs.name
    lambda       = aws_cloudwatch_log_group.lambda.name
  }
}
