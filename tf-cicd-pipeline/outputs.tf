
output "DockerHubUsername" {
  value = jsondecode(aws_secretsmanager_secret_version.DuckerHubCreds.secret_string) [*]
  sensitive = true
}

output "DockerHubPass" {
  value = jsondecode(aws_secretsmanager_secret_version.DuckerHubCreds.secret_string) [*]
  sensitive = true
}