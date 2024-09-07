
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair "terraform-lab" to AWS
resource "aws_key_pair" "kp" {
  key_name   = "terraform-lab"
  public_key = tls_private_key.pk.public_key_openssh

 # excute this command localy and save "terraform-lab.pem" to .ssh 
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/terraform-lab.pem"
  }
}