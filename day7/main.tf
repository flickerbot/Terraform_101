provider "aws" {
  region = "us-east-1"
}

/*import {
  to = aws_instance.example
  id = "i-0e1aee54377f5bf10"
}
*/
#terraform plan -generate-config-out=generated_resources.tf
# generating the terraform script using this cmd 


resource "aws_instance" "example" {
  ami                                  = "ami-0e001c9271cf7f3b9"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1c"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = "sessionmanagerconnect"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  key_name                             = "rsan"
  monitoring                           = false
  placement_group                      = null
  placement_partition_number           = 0
  private_ip                           = "172.31.7.121"
  secondary_private_ips                = []
  security_groups                      = ["launch-wizard-1"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0ddd58765a893d803"
  tags = {
    Name = "Netflix-Clone"
  }
  tags_all = {
    Name = "Netflix-Clone"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0ecd5e0724ea9130c"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 2
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 100
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 0
    volume_size           = 25
    volume_type           = "gp2"
  }
}

