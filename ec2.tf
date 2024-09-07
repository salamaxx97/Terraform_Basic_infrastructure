resource "aws_security_group" "SG" {
  for_each = var.security_groups
  name     = each.value
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = each.value
  }
}

# Ingress rule for public security group to allow ssh traffic from anywhere
resource "aws_security_group_rule" "public_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.SG["public"].id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.SG]
}

# Ingress rule for private security group to allow ssh traffic from public security group
resource "aws_security_group_rule" "private_ingress_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.SG["public"].id

  security_group_id = aws_security_group.SG["private"].id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.SG]
}

# Egress rule for all security groups to allow all outbound traffic
resource "aws_security_group_rule" "all_egress" {
  for_each    = var.security_groups
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1" # Allows all protocols
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.SG[each.key].id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.SG]
}


# Public EC2 instance with Nginx
resource "aws_instance" "instance" {
  for_each                    = var.instances
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnets[each.key].id
  security_groups             = [aws_security_group.SG[each.key].id]
  associate_public_ip_address = each.value[1]
  key_name = aws_key_pair.kp.key_name

  tags = {
    Name = each.value[0]
  }
}

