resource "aws_s3_bucket" "statebucket" {
  bucket = "salama-state-bucket"

  tags = {
    Name = "state bucket"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket" {
  bucket = aws_s3_bucket.statebucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode   = "PROVISIONED"   # Use provisioned mode for free tier eligibility
  read_capacity  = 1               # 1 RCU to stay within free tier
  write_capacity = 1               # 1 WCU to stay within free tier
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" # String type
  }

  tags = {
    Name        = "Terraform State Lock Table"
  }
}