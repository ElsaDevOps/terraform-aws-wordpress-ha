terraform {
  backend "s3" {
    bucket       = "terraform-state-wordpress-elsa"
    key          = "wordpress/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}