# Terraform Lab: Basic Network Infrastructure on AWS

## Lab Objective

Create a basic network infrastructure on AWS using Terraform, including a VPC, subnets, an Internet Gateway, a NAT Gateway, route tables, and security groups. Configure Terraform to use an S3 bucket for state management.

## Lab Tasks

1. **S3 Backend Configuration:**
   - Configure Terraform to store its state in an S3 bucket. Use DynamoDB for state locking.

2. **VPC Creation:**
   - Create a VPC with a CIDR block (e.g., 10.0.0.0/16).

3. **Subnets:**
   - Create one public subnet and one private subnet within the VPC.

4. **Internet Gateway (IGW):**
   - Attach an Internet Gateway to the VPC.
   - Update the route table for the public subnet to route traffic to the IGW.

5. **NAT Gateway:**
   - Create a NAT Gateway in the public subnet.
   - Update the route table for the private subnet to route traffic through the NAT Gateway.

6. **Security Groups (SG):**
   - Create a security group that allows SSH access (port 22) from any IP.

7. **Bonus Task - PEM File:**
   - Optionally, create an SSH key pair (PEM file) using Terraform, and store it securely.


