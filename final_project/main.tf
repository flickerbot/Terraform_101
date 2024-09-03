resource "aws_vpc" "My_custom_vpc" {
  
  cidr_block = var.cidr
}


resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.My_custom_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone ="us-east-1a"
  map_public_ip_on_launch="true"

}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.My_custom_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch ="true"
}
 

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.My_custom_vpc.id
    
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.My_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
} 


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.RT.id
}




#aws security group 
resource "aws_security_group" "Mysg" {

  #lifecycle { create_before_destroy = true }
name = "mySG-id"
vpc_id = aws_vpc.My_custom_vpc.id

 ingress {
    from_port       = 443
    to_port         = 443
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port       = 80
    to_port         = 80
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
    from_port       = 22
    to_port         = 22
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_s3_bucket" "S3Bucket" {
    bucket="mytestbuckk701"
  
}

resource "aws_instance" "aws_instance0" {
  
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t3.micro"
 vpc_security_group_ids= [aws_security_group.Mysg.id]
  subnet_id=aws_subnet.subnet1.id
   user_data = base64encode(file("userdata1.sh"))
    iam_instance_profile   = aws_iam_instance_profile.aws_s3_instance_profile.name

root_block_device {
    volume_size = 20 # in GB <<----- I increased this!
    volume_type = "gp3"
     
  }

  lifecycle {
    prevent_destroy = true
  }

}
resource "aws_instance" "aws_instance01" {
  
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t3.micro"
   vpc_security_group_ids= [aws_security_group.Mysg.id]
   subnet_id=aws_subnet.subnet2.id
   user_data = base64encode(file("userdata.sh"))
    iam_instance_profile   = aws_iam_instance_profile.aws_s3_instance_profile.name
}


resource "aws_lb" "LB" {
  name               = "test-lb-tf"
 # vpc_id = aws_vpc.My_custom_vpc.id
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Mysg.id]
  #subnets            = [for subnet in aws_vpc.My_custom_vpc.id.aws_subnet.public : subnet.id]
  subnets = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]

}

resource "aws_lb_target_group" "lbtarget-grp" {
  name     = "mylb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.My_custom_vpc.id
 health_check {
   path = "/"
   port = "traffic-port"
 }
  }


resource "aws_lb_target_group_attachment" "tg-attachment" {
  
  target_group_arn = aws_lb_target_group.lbtarget-grp.arn
  target_id        = aws_instance.aws_instance0.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-attachment2" {
  
  target_group_arn = aws_lb_target_group.lbtarget-grp.arn
  target_id        = aws_instance.aws_instance01.id
  port             = 80
}




resource "aws_lb_listener" "mylistner" {
  load_balancer_arn = aws_lb.LB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbtarget-grp.arn
}
}


#IAM logic 

resource "aws_iam_role" "aws_s3_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


}

resource "aws_iam_instance_profile" "aws_s3_instance_profile" {
  name = "test_instance_profile"
  role = aws_iam_role.aws_s3_role.name
}





resource "aws_iam_role_policy" "my-s3-read-policy" {
  name   = "s3_aws_read_policy"
  role   = "test_role"
  policy = data.aws_iam_policy_document.s3_read_permissions.json
}


data "aws_iam_policy_document" "s3_read_permissions" {
  statement {
    effect = "Allow"

    actions = [
             "*"
    ]

    resources = ["arn:aws:s3:::mytestbuckk701",
                  "arn:aws:s3:::mytestbuckk701/*",
                 
    ]
  }
}


















output "loadbalancerdnssssssssssssssssssssssssssssssssssss" {
  
  value= aws_lb.LB.dns_name


}