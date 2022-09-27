resource "aws_secretsmanager_secret" "DockerHub" {
  name = "docker-hub-creds"
}

resource "aws_secretsmanager_secret_version" "DuckerHubCreds" {
  secret_id = aws_secretsmanager_secret.DockerHub.id
  secret_string = jsonencode(var.docker-hub-creds-SM)
}