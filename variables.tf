variable "devs" {
	default	= []
}

variable "aws_region" {
  default = ""
}

variable "aws_keys" {
	type		= map
	default = {	
		"a_key" = ""
		"s_key" = ""
	}
}

variable "ami_name" {
    default = ""
}
variable "ami_id" {
    default = ""
}
variable "template_name" {
	default = ""
}

variable "instance_type" {
	default = ""
}

variable "db_name" {
	default = ""
}

variable "db_username" {
	default = ""
}

variable "db_instance_type" {
	default = ""
}

variable "db_engine" {
	default = ""
}

variable "db_engine_version" {
	default = ""
}

variable "db_storage_type" {
	default = ""
}

variable "db_allocated_storage" {
	default = ""
}

variable "db_port" {
	default = ""
}