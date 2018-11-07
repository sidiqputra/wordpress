#################################################################################
#################################################################################
#################################################################################

provider "aws" {
  region     = "ap-southeast-1"
}

#################################################################################
#################################################################################
#################################################################################

module "ec2_instance" {
  source = "../modules/ec2_instance/"

  instance_count 	= $1
  tags_name		= "wordpress"
  tags_hostname		= "ws-wordpress"
  tags_title_number	= 1

  ami                         = "ami-xxxx"
  instance_type               = "m5.large"
  key_name                    = "wordpress"
  monitoring                  = true
  vpc_security_group_ids      = ["sg-xxx"]
  subnet_id                   = "subnet-xxxx"
  associate_public_ip_address = false
  user_data		      = "./provisioning/userdata.txt"

  root_block_device = {
    volume_size = "200"
    volume_type = "gp2"
  }

  tags = {
    ServiceType = "webservice"
    ServiceGroup= "wordpress"
    CreateBy    = "terraform"
}
}

#################################################################################
#################################################################################
#################################################################################

resource "null_resource" "this" {
  triggers {
    cluster_instance_ids = "${join("\n", module.ec2_instance.id)}"
  }

  provisioner "local-exec" {
    working_dir = "../../hosts/"
    command = "echo '[ws:vars] \nansible_ssh_private_key_file = /home/ubuntu/.key/id_rsa \n\n[ws:children] \nwordpress \n\n[wordpress]' > inventory"
  }

  provisioner "local-exec" {
    working_dir = "../../hosts/"
    command = "echo '${join("\n", formatlist("%s ansible_host=%s ansible_port=22 ansible_user=ubuntu", module.ec2_instance.tags_hostname, module.ec2_instance.private_ip))}' >> inventory"
  }

}

#################################################################################
#################################################################################
#################################################################################

output "internal_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = "${module.ec2_instance.private_ip}"
}

output "tags" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = "${module.ec2_instance.tags_name}"
}
