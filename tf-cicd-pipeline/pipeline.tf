/* ## terraform plan stage
resource "aws_codebuild_project" "tf-plan" {
  name          = var.build_name-tf-plan
  description   = "building terraform plan"
  service_role  = aws_iam_role.CodeBuildRole.arn

  artifacts {
    type = var.artifacts_type-tf-plan
  }


  environment {
    compute_type                = var.compute_type-tf-plan
    image                       = var.image-tf-plan
    type                        = var.image_type-tf-plan
    image_pull_credentials_type = var.image_pull_credentials_type-tf-plan
    registry_credential {
      credential          = aws_secretsmanager_secret.DockerHub.arn
      credential_provider = var.credential_provider-tf-plan
    }
  }
  source {
    type      = var.source_type-tf-plan
    buildspec = file(var.buildspec_path-tf-plan)

  }
}
*/

## terraform apply stage
resource "aws_codebuild_project" "tf-apply" {
  name          = var.build_name-tf-apply
  description   = "building terraform apply"
  service_role  = aws_iam_role.CodeBuildRole.arn

  artifacts {
    type = var.artifacts_type-tf-apply
  }


  environment {
    compute_type                = var.compute_type-tf-apply
    image                       = var.image-tf-apply
    type                        = var.image_type-tf-apply
    image_pull_credentials_type = var.image_pull_credentials_type-tf-apply
    registry_credential {
      credential          = aws_secretsmanager_secret.DockerHub.arn
      credential_provider = var.credential_provider-tf-apply
    }
  }
  source {
    type      = var.source_type-tf-plan
    buildspec = file(var.buildspec_path-tf-apply)

  }
}

## Building a pipeline
resource "aws_codepipeline" "tf-cicd-pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.PipelineRole.arn
  artifact_store {
    location = aws_s3_bucket.WebHostingArtifacts.id
    type     = "S3"
  }
  stage {
    name = var.source_stage_name
    action {
      category         = var.source_category
      name             = var.source_name
      owner            = var.source_owner
      provider         = var.source_provider
      version          = var.source_version
      output_artifacts = [var.source_output_artifacts]
      configuration    = {
        FullRepositoryId     = var.source_repository
        BranchName           = var.source_branch
        ConnectionArn        = aws_codestarconnections_connection.GitHub.arn
        OutputArtifactFormat = var.source_output_artifact_format
      }
    }
  }
/* ## terraform plan stage
  stage {
    name = var.plan_stage_name
    action {
      category         = var.plan_category
      name             = var.plan_name
      owner            = var.plan_owner
      version          = var.plan_version
      provider         = var.plan_provider
      input_artifacts  = [var.plan_input_artifacts]
      output_artifacts = [var.plan_output_artifacts]
      configuration    = {
        ProjectName = aws_codebuild_project.tf-plan.name
      }
    }
  }
*/
## terraform apply stage
  stage {
    name = var.deploy_stage_name
    action {
      category         = var.deploy_category
      name             = var.deploy_name
      owner            = var.deploy_owner
      version          = var.deploy_version
      provider         = var.deploy_provider
      input_artifacts  = [var.deploy_input_artifacts]
      output_artifacts = [var.deploy_output_artifacts]
      configuration    = {
        ProjectName = aws_codebuild_project.tf-apply.name
      }
    }
  }
}