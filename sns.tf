

# SNS — Notification Topic

resource "aws_sns_topic" "pipeline_alerts" {
  name = "${var.project_name}-alerts"

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Email subscription — your email gets notified
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.pipeline_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
