remote_state {
  backend = "s3"
  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    profile = "niket"
    bucket = "terragrunt-eks-tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"

    assume_role  ={
      role_arn = "arn:aws:iam::261138456668:role/terraform"
      session_name = "terraform"
    }
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "ap-south-1"
  profile = "niket"
  
  assume_role {
    session_name = "arn-role-session"
    role_arn = "arn:aws:iam::261138456668:role/terraform"
  }
}
EOF
}