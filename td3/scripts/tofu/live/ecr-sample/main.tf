provider "aws" {
  region = "us-east-2"
}

module "repo" {
  source = "github.com/TheoPhan77/devops-base//td3/scripts/tofu/modules/ecr-repo"

  name = "sample-app"
}
