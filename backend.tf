terraform {
    backend "s3" {
        bucket = "ta-terraform-tfstates-317752533111-olga"
        key = "playground/olga/terraform.tfstates"
        dynamodb_table = "terraform-lock"
    }
}