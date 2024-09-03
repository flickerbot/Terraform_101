provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}


resource "aws_vpc" "Test-vpc" {
   cidr_block = var.cidr

}


 resource "aws_key_pair" "Test_keypair" {
    key_name   = "temp-keypair"
    public_key = file("/home/oem/.ssh/id_rsa.pub")
 }

 resource "aws_subnet" "Test_subnet" {
    vpc_id     = aws_vpc.Test-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}
 

resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Test-vpc.id
}

resource "aws_route_table" "Test-rt" {
      vpc_id = aws_vpc.Test-vpc.id
       route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Test-igw.id
  }
}


resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.Test_subnet.id
  route_table_id = aws_route_table.Test-rt.id
}


resource "aws_security_group" "Test-sg" {
  


  vpc_id = aws_vpc.Test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from any IP. Replace with a more restrictive IP range for better security.
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from any IP. Replace with a more restrictive IP range for better security.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "server" {
  ami                    = "ami-066784287e358dad1"
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.Test_keypair.key_name
  vpc_security_group_ids = [aws_security_group.Test-sg.id]
  subnet_id              = aws_subnet.Test_subnet.id


 connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ec2-user/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",  # Update package lists (for ubuntu)
      "sudo yum install -y python3-pip",  # Example package installation
      "cd /home/ec2-user",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }









} 


