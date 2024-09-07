aws_region  = "us-east-1"
aws_profile = "default"
vpc_cidr    = "10.0.0.0/16"
subnet_cidrs = {
  private = ["10.0.0.0/24", false]
  public  = ["10.0.1.0/24", true]
}
security_groups = {
  "private" = "allow_private_ssh"
  "public"  = "allow_public_ssh"
}

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
ami                = "ami-0a0e5d9c7acc336f1"
instance_type      = "t2.micro"
instances = {
  public  = ["PublicInstance", true]
  private = ["PrivateInstance", false]
}
