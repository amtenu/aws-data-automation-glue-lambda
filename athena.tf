
# athina runs SQL queries directly against the processed parquet files in S3.
# No database to provision or manage and it's pay per query
resource "aws_athena_workgroup" "main" {
  name        = "${var.project_name}-workgroup"
  description = "Athena workgroup for ${var.project_name} pipeline"
  state       = "ENABLED"

  configuration {
    # limit per query :- protects against runaway scans and cost spikes.200MB cap keeps queries cheap
    bytes_scanned_cutoff_per_query     = 200000000
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = false
    requester_pays_enabled             = true

    result_configuration {
      output_location = "s3://${var.s3_bucket_name}/athena/"
    }
  }

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}
