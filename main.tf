#resource "resource_type" "resource_name" for terraform
resource "aws_s3_bucket" "ta_backend_bucket" {
  #bucket = "bucket_name_globally_unique" for aws
  bucket = "ta-terraform-tfstates-317752533111-olga"

  #meta-data
  lifecycle {
      prevent_destroy = true
    }

    tags = {
        Name = "ta-terraform-tfstates-317752533111-olga"
        Environment = "Test"
    }
}

resource "aws_s3_bucket_versioning" "version_my_bucket" {
    #redirect to get the name of the bucket we want to versioning
  bucket = aws_s3_bucket.ta_backend_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock_tbl" {
  name           = "terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags           = {
    Name = "terraform-lock"
  }
}