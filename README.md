# terraform-practice-vimala
pushing new branch

Here you go, Thangaraj — a clean, sharp, **interview-ready note** summarizing all the important points you asked above.
No nonsense, no fluff, just the exact facts you need to speak confidently.

---

# **Terraform Remote Backend – Interview Note (S3 + DynamoDB)**

### **What is Terraform State?**

Terraform state tracks the real AWS resources created.
Without state, Terraform has **no memory** of existing infrastructure.

### **Why Remote Backend?**

Local state is risky — gets deleted, corrupted, or stuck on one engineer’s laptop.
Remote backend (S3 + DynamoDB) makes the project **team-safe and enterprise-ready**.

---

# **How to Set Up Remote Backend (S3 + DynamoDB)**

### **1. Create S3 Bucket (to store remote state)**

* S3 → Create bucket
* Name: `tfstate-<project>`
* Region: same as deployment (ex: ap-south-1)
* Versioning: **ON**
* Public access: **Blocked**
* Bucket Key: **OFF**

### **2. Create DynamoDB Table (for state locking)**

* Name: `tf-locks`
* Partition key: `LockID` (String)

This prevents two developers running `apply` at the same time.

---

# **3. Create backend.tf in Terraform project**

```hcl
terraform {
  backend "s3" {
    bucket         = "tfstate-vimala"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
```

* `key` is the path inside the S3 bucket.
* `dev` represents the environment.
* Backend files use only **string and bool**.

---

# **4. Migrate Local State to Remote Backend**

```bash
terraform init -migrate-state
```

Terraform will:

* Read existing local `terraform.tfstate`
* Copy it automatically into S3
* Use DynamoDB for lock management

You **never** manually upload state to S3.

---

# **AccessDenied?**

It means the IAM user used by Terraform doesn’t have S3 permissions.
Check the user:

```bash
aws sts get-caller-identity
```

Attach these permissions to that exact user:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::tfstate-vimala"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::tfstate-vimala/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-south-1:<ACCOUNT-ID>:table/tf-locks"
    }
  ]
}
```

---

# **Can I open terraform.tfstate in browser?**

**No.**
It is private and must stay private.
Only Terraform can read it.

---

# **How a New Developer Continues Your Work?**

If you leave the company and a new dev joins:

1. They clone the Git repo.
2. They configure AWS credentials.
3. They run:

```bash
terraform init
terraform plan
```

Terraform automatically reads the remote state from S3.
They continue from where you left off, safely.

**This is the whole point of using remote backend.**

---

If you need this as a **PDF**, I can generate it.
