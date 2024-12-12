terraform {
  backend "s3" {
    bucket = "idea-box-terraform"
    key    = "state/terraform.tfstate"
    region = "eu-west-3"
  }
}

module "database" {
  source = "./modules/database"
}

module "backend" {
  source = "./modules/backend"
}