# 🚀 Milketa (ምልከታ)  AWS Data Automation Pipeline
> Milketa (ምልከታ) is Amharic for 'direction of information' — exactly what this pipeline delivers: raw data in, clear direction out
> Serverless data pipeline using AWS Glue, S3, CloudWatch, and SNS — deployed with Terraform (IaC). Built as a generic, adaptable foundation; Athena querying is the next piece in progress.

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

---

## 📐 Architecture

```
CSV Upload
   │
   ▼
S3 Data Lake (landing/)
   │
   ▼
Lambda (Python) — detects upload, triggers pipeline
   │
   ▼
Glue Crawler — scans file, infers schema automatically
   │
   ▼
Glue Data Catalog — stores schema metadata
   │
   ▼
Glue ETL (PySpark) — cleans, transforms, writes Parquet
   │
   ▼
S3 Data Lake (processed/)
   │
   ▼
Athena — SQL queries on clean Parquet data
   │
   ▼
Business insights in seconds
```
> CloudWatch monitors every step. SNS sends email alerts on success, failure, or billing threshold breach.
>
# Why Each Technology Was Chosen

S3 — Infinitely scalable, serverless, and the natural home for all data in AWS. Stores both raw and processed data as the single source of truth.

Lambda — Responds to S3 events instantly with zero infrastructure to manage and near-zero cost. Only runs when a file arrives.

Glue Crawler — Automatically discovers schema without manual configuration. The pipeline works with any CSV structure a company uploads — no hardcoding column names.

Glue ETL with PySpark — PySpark is the industry standard for large-scale data transformation. AWS Glue is the managed Spark service that eliminates cluster management entirely. Lambda has a 15 minute limit and 10GB memory cap — Glue scales horizontally with worker nodes for any dataset size.

Parquet — Columnar format that dramatically reduces both storage costs and Athena query costs compared to raw CSV. Athena reads only the columns a query touches rather than scanning entire rows.

Athena — Serverless SQL. No database to provision, no cluster to manage, pay only per query. Built for analytical workloads on S3 data, not transactional operations.

Terraform — All infrastructure is reproducible, version controlled, and deployable with a single command.
---

## 🛠️ Tech Stack

| Service    | Purpose                           | Free Tier     |
| ---------- | --------------------------------- | ------------- |
| S3         | Data lake storage                 | ✅ 5GB        |
| Lambda     | Event-driven pipeline trigger     | ✅ 1M reqs    |
| AWS Glue   | Crawler + ETL transformation      | ⚠️ ~$0.08/run |
| AWS Glue Catalog |	Schema metadata store	| Free.         |
| AWS Glue ETL | PySpark transformation	| ~$0.08/run.          |
| Athena     | SQL queries on S3 data            | ⚠️ $5/TB      |
| IAM        | Least-privilege service roles     | ✅ Free       |
| CloudWatch | Logs & monitoring                 | ✅ Free tier  |
| SNS        | Email alerts for failures/billing | ✅ Free tier  |
| Terraform  | Infrastructure as Code	| Open source          |

---

# Project Structure

aws-data-automation-glue-lambda/
├── main.tf                    # Terraform provider and version config
├── s3.tf                      # S3 data lake bucket and security
├── iam.tf                     # Glue and Lambda IAM roles and policies
├── glue.tf                    # Glue Catalog database and Crawler
├── athena.tf                  # Athena Workgroup with cost protection
├── cloudwatch.tf              # Log groups and billing alarm
├── sns.tf                     # Alerts topic and email subscription
├── variables.tf               # All input variables
├── outputs.tf                 # Deployment output values
├── terraform.tfvars.example   # Safe example config
└── .gitignore                 # Protects secrets and state files



---

# Security Design

Every service runs under a dedicated least-privilege IAM role scoped only to the resources it needs.

Glue role — read/write access to the specific S3 bucket only, write access to /aws-glue/* CloudWatch log groups, Glue and Lake Formation APIs. glue:* kept broad because AWS requires it for the managed service to function internally.

Lambda role — StartCrawler, GetCrawler, StartJobRun only. Read-only access to the specific S3 bucket. Publish to SNS topic.

S3 bucket — versioning enabled for data recovery, all four public access block settings enabled, AES256 server-side encryption, no public access of any kind.

---

## ⚠️ Cost Control

- AWS Billing alarm set at **$5** — email alert instant
- Glue Crawler runs **once daily at 8am UTC**
- Athena has **200MB per query scan limit**
- CloudWatch logs retained for **7 days** only
- Always run `terraform destroy` when not actively developing

---


## 📌 Roadmap

- [x] Project foundation — variables, structure, gitignore
- [ ] Step 2 — S3 bucket + versioning + lifecycle rules
- [ ] Step 3 — IAM roles for Glue and Lambda
- [ ] Step 4 — CloudWatch logging + SNS alerts
- [ ] Step 5 — Glue ETL + Crawler
- [ ] Step 6 — Lambda trigger function
- [ ] Step 7 — End to end demo + LinkedIn post
- [ ]
## 📌 RoadmapBuild Status

- [x] Terraform infrastructure — all 9 files written and committed
- [x] S3 data lake with versioning, encryption, public access block
- [x] IAM least-privilege roles for Glue and Lambda
- [x] Glue Data Catalog and Crawler
- [x] Athena Workgroup with cost protection
- [x] CloudWatch log groups and billing alarm
- [x] SNS alerts wired to billing alarm
- [x] Terraform plan verified clean — 22 resources ready to deploy
      
# In Progress
- [ ]  terraform apply — deploying infrastructure to AWS
- [ ]  Lambda Python trigger function
- [ ]  Glue ETL PySpark transformation script
- [ ]  Sample ecommerce CSV for end-to-end testing
- [ ]  End-to-end pipeline demo

# Planned
- [ ] QuickSight or static HTML dashboard
- [ ] Multi-tenant S3 structure per company
- [ ] AWS Step Functions for industry routing
- [ ] Next.js frontend for Milketa SaaS product
---

## 🚀 Deploy

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- AWS account

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/aws-data-automation-glue-lambda.git
cd aws-data-automation-glue-lambda

# 2. Set your variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Deploy
terraform init
terraform plan
terraform apply

# 4. Destroy when done (avoid charges!)
terraform destroy
```

---



## 👤 Author

**Amanuel**

---

## 📄 License

MIT
