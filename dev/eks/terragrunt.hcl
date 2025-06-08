terraform {
    source = "git@github.com:niketvjoshi/aws-infra-modules.git//eks?ref=eks-v0.0.1"
}

include "root" {
    path = find_in_parent_folders()
}

include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
}

inputs = {
    eks_version = "1.31"
    env         = include.env.locals.env
    eks_name   = "demo"
    subnet_ids = dependency.vpc.outputs.private_subnet_ids

    node_groups = {
        generate = {
            capacity_type = "ON_DEMAND"
            instance_type = ["t3a.xlarge"]
            scaling_config = {
                desired_size = 1
                max_size     = 3
                min_size     = 0
            }
        }
    }
}

dependency "vpc" {
    config_path = "../vpc"

    mock_outputs = {
        private_subnet_ids = ["subnet-12345678", "subnet-23456789", "subnet-34567890"]
    }
}


