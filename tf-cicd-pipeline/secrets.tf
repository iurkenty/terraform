resource "aws_secretsmanager_secret" "DockerHub" {
  name = "docker_hub_creds"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "DuckerHubCreds" {
  secret_id = aws_secretsmanager_secret.DockerHub.id   ## Monthly cost for 2 secrets $0.19 with 1000 API calls
  secret_string = jsonencode(var.docker-hub-creds-SM)
}
