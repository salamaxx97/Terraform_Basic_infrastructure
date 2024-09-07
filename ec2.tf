resource "aws_security_group" "SG" {
  for_each = var.security_groups
  name     = each.value
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = each.value
  }
}

# Ingress rule for public security group to allow HTTP traffic from anywhere
resource "aws_security_group_rule" "public_ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.SG["public"].id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.SG]
}

# Ingress rule for private security group to allow HTTP traffic from public security group
resource "aws_security_group_rule" "private_ingress_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
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


# # Public EC2 instance with Nginx
# resource "aws_instance" "public" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public.id
#   security_groups        = [aws_security_group.public.id]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update
#               apt-get install -y nginx
#               rm /etc/nginx/sites-enabled/default
#               echo 'server {
#                       listen 80;
#                       location / {
#                           proxy_pass http://${aws_instance.private.private_ip};
#                       }
#               }' > /etc/nginx/sites-available/default
#               ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
#               systemctl restart nginx
#               EOF

#   tags = {
#     Name = "NginxPublicInstance"
#   }
# }

# # Private EC2 instance with Apache
# resource "aws_instance" "private" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.private.id
#   security_groups        = [aws_security_group.private.id]
#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update
#               apt-get install -y a pache2
#               echo "Hello from $(hostname)" > /var/www/html/index.html
#               systemctl restart apache2
#               EOF

#   tags = {
#     Name = "ApachePrivateInstance"
#   }
# }
