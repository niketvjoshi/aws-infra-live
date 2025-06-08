terraform {
    source = "git@github.com:niketvjoshi/aws-infra-modules.git//vpc?ref=vpc-v0.0.1"
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
    env             = include.env.locals.env
    azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    private_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
    public_subnets  = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/dev-demo"  = "owned"
    }

    public_subnet_tags = {
        "kubernetes.io/role/elb"         = "1"
        "kubernetes.io/cluster/dev-demo" = "owned"
    }
}