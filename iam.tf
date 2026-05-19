
# IAM — Glue Service Role

resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy" "glue_policy" {
  name = "${var.project_name}-glue-policy"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "lakeformation:*",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketAcl",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeRouteTables",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcAttribute",
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = [
          "arn:aws:s3:::aws-glue-*/*",
          "arn:aws:s3:::*/*aws-glue-*/*",
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [
          "arn:aws:s3:::crawler-public*",
          "arn:aws:s3:::aws-glue-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*:/aws-glue/*"
      },
      {
        Effect = "Allow"
        Action = ["ec2:CreateTags", "ec2:DeleteTags"]
        Resource = [
          "arn:aws:ec2:*:*:network-interface/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:instance/*"
        ]
        Condition = {
          "ForAllValues:StringEquals" = {
            "aws:TagKeys" = ["aws-glue-service-resource"]
          }
        }
      }
    ]
  })
}


# IAM — Lambda Execution Role for the project

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_glue_trigger" {
  name = "${var.project_name}-lambda-glue-trigger"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["glue:StartCrawler", "glue:GetCrawler", "glue:StartJobRun"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      }
    ]
  })
}
