resource "aws_instance" "nat" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro" # Puedes ajustar el tipo de instancia según tus necesidades
  subnet_id      = var.public_subnet_ids[0] # Se coloca en la primera subred pública
  vpc_security_group_ids = [aws_security_group.nat_sg.id]

  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    amazon-linux-extras install epel -y
    yum install iptables-services -y
    systemctl start iptables
    systemctl enable iptables
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables-save > /etc/sysconfig/iptables
    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  EOT

  tags = {
    Name = "nat-instance"
  }
}


resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Security group for NAT instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.private_subnets_cidr[0], var.private_subnets_cidr[1]] # Permitir tráfico desde las subredes privadas
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
