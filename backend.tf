terraform {
    backend "s3" {
        bucket = "ta-terraform-tfstates-054867543329-olga"
        key = "playground/olga/terraform.tfstates"
        dynamodb_table = "terraform-lock"
    }
}