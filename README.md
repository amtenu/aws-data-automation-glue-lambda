# 🚀 AWS Data Automation Pipeline

> End-to-end serverless data pipeline using AWS Glue, Lambda, S3, and Athena — fully deployed with Terraform (IaC)

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

---

## 📐 Architecture

```
Raw Data (CSV/JSON)
       │
       ▼
  AWS Lambda  ──────────────────────────►  CloudWatch Logs
  (S3 trigger)                                    │
       │                                          ▼
       ▼                                   SNS Email Alert
  S3 Data Lake
  ├── landing/      ← raw files
  ├── processed/    ← cleaned Parquet
  ├── athena/       ← query results
  └── scripts/      ← Glue ETL scripts
       │
       ▼
  Glue Crawler  →  Glue Data Catalog
       │
       ▼
  Glue ETL Job (PySpark → Parquet)
       │
       ▼
  Athena Workgroup (SQL queries)
```

---

## 🛠️ Stack

| Service    | Purpose                           | Free Tier     |
| ---------- | --------------------------------- | ------------- |
| S3         | Data lake storage                 | ✅ 5GB        |
| Lambda     | Event-driven pipeline trigger     | ✅ 1M reqs    |
| AWS Glue   | Crawler + ETL transformation      | ⚠️ ~$0.08/run |
| Athena     | SQL queries on S3 data            | ⚠️ $5/TB      |
| IAM        | Least-privilege service roles     | ✅ Free       |
| CloudWatch | Logs & monitoring                 | ✅ Free tier  |
| SNS        | Email alerts for failures/billing | ✅ Free tier  |

---

## 📁 Project Structure

```
├── variables.tf             # Input variables
├── outputs.tf               # Deployment outputs (coming soon)
├── terraform.tfvars.example # Example variables (safe to commit)
└── .gitignore               # Protects secrets and state files
```

---

## 📌 Roadmap

- [x] Project foundation — variables, structure, gitignore
- [ ] Day 2 — S3 bucket + versioning + lifecycle rules
- [ ] Day 3 — IAM roles for Glue and Lambda
- [ ] Day 4 — CloudWatch logging + SNS alerts
- [ ] Day 5 — Glue ETL + Crawler
- [ ] Day 6 — Lambda trigger function
- [ ] Day 7 — End to end demo + LinkedIn post

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

## ⚠️ Cost Control

- AWS Billing alarm set at **$5** — email alert instant
- Glue Crawler runs **once daily at 8am UTC**
- Athena has **200MB per query scan limit**
- CloudWatch logs retained for **7 days** only
- Always run `terraform destroy` when not actively developing

---

## 👤 Author

**Amanuel**

---

## 📄 License

MIT
