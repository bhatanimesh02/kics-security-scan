variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "DB_USERNAME" {}
variable "DB_PASSWORD" {}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-042e8287309f5df03"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}
