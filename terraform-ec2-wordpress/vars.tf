variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}


variable "AWS_REGION" {
  default = "ap-south-1"
}


variable AMIS {
  type        = map(string)
  default     = {
     ap-south-1 = "ami-02b5fbc2cb28b77b8"
  }
  
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "keypairs/automation"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keypairs/automation.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
