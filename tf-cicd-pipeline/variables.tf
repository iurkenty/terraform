variable "region" {}

variable "docker-hub-creds-SM" {
  description = "Credential for a Docker-Hub account"
  type = map(string)
  default = {
    Username = "iurkenty"
    Password = "Iurkenty123$"
  }
}

variable "SecretsManagerDocker" {
  type = string
}
variable "CodePipelineConnector" {
  type = string
}
variable "BucketVersioning" {
  type = string
}