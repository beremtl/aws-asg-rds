provider "aws" {
#	version	= "~> 2.43.0"
	region	= var.aws_region
	access_key	= var.aws_keys.a_key
	secret_key	= var.aws_keys.s_key
}

resource "random_password" "password" {
	length  = "8"
  special = false
  number	= true
	upper	= true
	lower	= true
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "destination" {                                  
  for_each      = data.aws_subnet_ids.default.ids           
  id    = each.value
} 

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

resource "aws_key_pair" "berem" {
  key_name   = "berem-deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_launch_template" "web" {
  name_prefix   = var.template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.berem.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [data.aws_security_group.default.id]
  }

  placement {
    availability_zone = "${var.aws_region}a"
  }
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.template_name
    }
  }
  user_data = base64encode(templatefile("${path.module}/template/db.sh.tpl",
		{
			host = aws_db_instance.db.address
      port = aws_db_instance.db.port
      username = aws_db_instance.db.username
      passwd = aws_db_instance.db.password
      db_name = aws_db_instance.db.name
		}))
  depends_on = ["aws_db_instance.db"]

}

resource "aws_autoscaling_group" "web" {
  availability_zones = ["${var.aws_region}a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.web.id}"
    version = "$Latest"
  }
  depends_on = ["aws_launch_template.web"]
}

resource "aws_db_instance" "db" {
  allocated_storage    = var.db_allocated_storage
  storage_type         = var.db_storage_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_type
  name                 = var.db_name
  username             = var.db_username
  password             = random_password.password.result
  skip_final_snapshot = true
  vpc_security_group_ids = [data.aws_security_group.default.id]
  port     = var.db_port
  tags = {
    Name = "db_postgres"
  }
}

resource "local_file" "dbsh" {
    content = templatefile("${path.module}/template/db.sh.tpl",
		{
			host = aws_db_instance.db.address
      port = aws_db_instance.db.port
      username = aws_db_instance.db.username
      passwd = aws_db_instance.db.password
      db_name = aws_db_instance.db.name
		})
    filename = "db.sh"
    depends_on = ["aws_db_instance.db"]
}