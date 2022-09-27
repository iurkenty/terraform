variable "region" {}

variable "docker-hub-creds-SM" {
  type = map(string)
}
variable "BucketVersioning" {}

## CodeBuild tf-plan
variable "build_name-tf-plan" {}
variable "artifacts_type-tf-plan" {}
variable "compute_type-tf-plan" {}
variable "image-tf-plan" {}
variable "image_type-tf-plan" {}
variable "image_pull_credentials_type-tf-plan" {}
variable "credential_provider-tf-plan" {}
variable "source_type-tf-plan" {}
variable "buildspec_path-tf-plan" {}

## CodeBuild tf-apply
variable "build_name-tf-apply" {}
variable "artifacts_type-tf-apply" {}
variable "compute_type-tf-apply" {}
variable "image-tf-apply" {}
variable "image_type-tf-apply" {}
variable "image_pull_credentials_type-tf-apply" {}
variable "credential_provider-tf-apply" {}
variable "source_type-tf-apply" {}
variable "buildspec_path-tf-apply" {}

## CodePipeline
variable "pipeline_name" {}

## Pipeline Source Stage
variable "source_stage_name" {}
variable "source_category" {}
variable "source_name" {}
variable "source_owner" {}
variable "source_provider" {}
variable "source_version" {}
variable "source_output_artifacts" {}
variable "source_repository" {}
variable "source_branch" {}
variable "source_output_artifact_format" {}

## Pipeline Deploy Stage
variable "deploy_stage_name" {}
variable "deploy_category" {}
variable "deploy_name" {}
variable "deploy_owner" {}
variable "deploy_provider" {}
variable "deploy_version" {}
variable "deploy_input_artifacts" {}
variable "deploy_output_artifacts" {}

## Pipeline Plan Stage
variable "plan_stage_name" {}
variable "plan_category" {}
variable "plan_name" {}
variable "plan_owner" {}
variable "plan_provider" {}
variable "plan_version" {}
variable "plan_input_artifacts" {}
variable "plan_output_artifacts" {}