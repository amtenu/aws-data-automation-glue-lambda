# glue Data Catalog Database
# stores the schema metadata discovered by the Crawler.
# athena uses this catalog to know how to query the S3 data
resource "aws_glue_catalog_database" "main" {
  name        = "${var.project_name}_catalog"
  description = "Glue Data Catalog for ${var.project_name} pipeline"
}

# glue Crawler
# scans the landing/ folder in S3, infers schema automatically,
# and registers the table definitions in the catalog database above
# Runs once daily at 8am UTC — triggered manually during development
resource "aws_glue_crawler" "main" {
  name          = "${var.project_name}-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.main.name

  s3_target {
    path = "s3://${var.s3_bucket_name}/landing/"
  }

  schedule = "cron(0 8 * * ? *)"

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}
