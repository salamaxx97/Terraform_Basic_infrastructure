resource "aws_security_group" "public" {
  name        = "allow_public_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_public_http" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "public_allow_outbounds" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "private" {
  name        = "allow_private_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_private_http"
  }
}

resource "aws_security_group_rule" "private_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.public.id
  security_group_id = aws_security_group.private.id
}


resource "aws_vpc_security_group_egress_rule" "privaate_allow_outbound" {
  security_group_id = aws_security_group.private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Public EC2 instance with Nginx
resource "aws_instance" " public" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  security_groups        = [aws_security_group.public.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              rm /etc/nginx/sites-enabled/default
              echo 'server {
                      listen 80;
                      location / {
                          proxy_pass http://${aws_instance.apache_private.private_ip};
                      }
              }' > /etc/nginx/sites-available/default
              ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
              systemctl restart nginx
              EOF

  tags = {
    Name = "NginxPublicInstance"
  }
}

# Private EC2 instance with Apache
resource "aws_instance" "private" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  security_groups        = [aws_security_group.private.id]
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              echo "Hello from $(hostname)" > /var/www/html/index.html
              systemctl restart apache2
              EOF

  tags = {
    Name = "ApachePrivateInstance"
  }
}
