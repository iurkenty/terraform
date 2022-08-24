variable "sysadmin" {
  type = list
  default = ["sysadmin1", "sysadmin2"]
}

variable "dbadmin" {
  type = list
  default = ["dbadmin1", "dbadmin2"]
}

variable "monitoruser" {
  type = list
  default = ["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"]
}

variable "account-alias" {
  type = list
  default = ["sysadmin1-gogreen", "sysadmin2-gogreen"]
}