variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "webserver-port" {
  type    = number
  default = 80
}

variable "mattermost-port" {
  type    = number
  default = 8065
}

variable "bastion-instance-type" {
  type    = string
  default = "t2.micro"
}

variable "application-instance-type" {
  type    = string
  default = "t3.medium"
}

variable "jobserver-instance-type" {
  type    = string
  default = "t3.medium"
}

variable "grafana-instance-type" {
  type    = string
  default = "t3.micro"
}

variable "prometheus-instance-type" {
  type    = string
  default = "t3.small"
}

variable "application-instance-count" {
  type    = number
  default = 2
}

variable "db-instance-type" {
  type    = string
  default = "db.r5.large"
}

variable "db-instance-count" {
  type    = number
  default = 3
}