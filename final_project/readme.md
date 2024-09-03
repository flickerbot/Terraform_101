VPC Creation: The aws_vpc resource creates a Virtual Private Cloud (VPC) with a CIDR block specified by the variable var.cidr.

Subnets:

    aws_subnet.subnet1: Creates a subnet in us-east-1a with a CIDR block of 10.0.1.0/24, enabling public IP allocation on launch.
    aws_subnet.subnet2: Creates another subnet in us-east-1b with a CIDR block of 10.0.0.0/24, also enabling public IP allocation on launch.

Internet Gateway: The aws_internet_gateway resource attaches an internet gateway to the VPC to allow internet access.

Route Table: The aws_route_table resource defines a route for all traffic (0.0.0.0/0) to be directed through the internet gateway.

Route Table Associations: Two associations are created to link the subnets to the route table:

    aws_route_table_association.a for subnet1.
    aws_route_table_association.b for subnet2.

Security Group: The aws_security_group resource (Mysg) allows inbound traffic on ports 80 (HTTP), 443 (HTTPS), and 22 (SSH) from any IP address. It permits all outbound traffic.

S3 Bucket: The aws_s3_bucket resource creates an S3 bucket named mytestbuckk701.

EC2 Instances:

    aws_instance.aws_instance0: Launches an EC2 instance in subnet1 with an AMI, instance type t3.micro, security group Mysg, and a 20 GB root volume. It uses user data from userdata1.sh and attaches an IAM instance profile.
    aws_instance.aws_instance01: Launches another EC2 instance in subnet2 with similar settings, but uses userdata.sh and the same IAM instance profile.

Load Balancer:

    aws_lb.LB: Creates an Application Load Balancer (ALB) that is external, with a security group Mysg and spans across both subnets.

Target Group:

    aws_lb_target_group.lbtarget-grp: Defines a target group for the ALB, listening on port 80 with HTTP protocol and health checks configured.

Target Group Attachments:

    aws_lb_target_group_attachment.tg-attachment: Attaches aws_instance.aws_instance0 to the target group.
    aws_lb_target_group_attachment.tg-attachment2: Attaches aws_instance.aws_instance01 to the target group.

Load Balancer Listener:

    aws_lb_listener.mylistner: Configures a listener on port 80 for the ALB that forwards traffic to the target group.

IAM Role and Policy:

    aws_iam_role.aws_s3_role: Creates an IAM role with a policy allowing EC2 instances to assume the role.
    aws_iam_instance_profile.aws_s3_instance_profile: Associates the IAM role with an instance profile.
    aws_iam_role_policy.my-s3-read-policy: Defines a policy allowing read access to the S3 bucket.

Outputs:

    loadbalancerdns: Outputs the DNS name of the load balancer.