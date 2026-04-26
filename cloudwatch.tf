
# CloudWatch — Log Groups


# Glue Crawler Log Group
resource "aws_cloudwatch_log_group" "glue_crawler" {
  name              = "/aws-glue/crawlers"
  retention_in_days = 7

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Glue ETL Job Log Group
resource "aws_cloudwatch_log_group" "glue_jobs" {
  name              = "/aws-glue/jobs"
  retention_in_days = 7

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Lambda Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-trigger"
  retention_in_days = 7

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}


# CloudWatch — Billing Alarm

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "${var.project_name}-billing-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 86400
  statistic           = "Maximum"
  threshold           = 5
  alarm_description   = "Alert when AWS bill exceeds USD $5"
  alarm_actions       = [aws_sns_topic.pipeline_alerts.arn]

  dimensions = {
    Currency = "USD"
  }

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}
