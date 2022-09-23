resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-plan"
  description   = "building terraform plan"
  service_role  = aws_iam_role.CodeBuildRole.arn

  artifacts {
    type = "CODEPIPELINE"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential          = var.SecretsManagerDocker
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
     type = "CODEPIPELINE"
     buildspec = file("codebuild/plan-buildspec.yml")

  }
}
resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-apply"
  description   = "building terraform apply"
  service_role  = aws_iam_role.CodeBuildRole.arn

  artifacts {
    type = "CODEPIPELINE"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential          = var.SecretsManagerDocker
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = file("codebuild/apply-buildspec.yml")

  }
}
