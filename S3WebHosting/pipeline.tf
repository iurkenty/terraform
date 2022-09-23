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

## Building a pipeline
resource "aws_codepipeline" "tf-cicd-pipeline" {
  name     = "tf-CICD-pipeline"
  role_arn = aws_iam_role.PipelineRole.arn
  artifact_store {
    location = aws_s3_bucket.WebHostingArtifacts.id
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tf_code"]
      configuration    = {
        FullRepositoryId     = "iurkenty/terraform"
        BranchName           = "master"
        ConnectionArn        = var.CodePipelineConnector
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
  stage {
    name = "Plan"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["tf_code"]
      output_artifacts = ["tf_plan"]
      configuration    = {
        ProjectName = "tf-cicd-plan"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["tf_plan"]
      output_artifacts = ["tf_deploy"]
      configuration    = {
        ProjectName = "tf-cicd-deploy"
      }
    }
  }
}