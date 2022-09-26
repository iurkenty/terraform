provider "aws" {
  region = var.region
}

## Bucket for the pipeline artifacts
resource "aws_s3_bucket" "WebHostingArtifacts" {
  bucket = "web-hosting-pipeline-iurkenty"
 }

resource "aws_s3_bucket_versioning" "versioningEnable" {
  bucket = aws_s3_bucket.WebHostingArtifacts.id
  versioning_configuration {
    status = var.BucketVersioning
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.WebHostingArtifacts.id
  acl    = "private"
}

## IAM role for the CodePipeline
resource "aws_iam_role" "PipelineRole" {
   name = "PipelineRole"
   assume_role_policy =  <<EOF
{
  "Version" : "2012-10-17",
  "Statement" :
  [
    {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : ["codepipeline.amazonaws.com"]
      },
      "Action" : "sts:AssumeRole"
    }
  ]
}
EOF
}
data "aws_iam_policy_document" "CodeStarConnection" {
  statement {
    sid = ""
    actions = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect = "Allow"
  }
  statement {
    sid = ""
    actions = ["codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "CodeStarConnectionPolicy" {
  name = "tf-cicd-pipeline-policy"
  policy = data.aws_iam_policy_document.CodeStarConnection.json
}
resource "aws_iam_role_policy_attachment" "CodeStarConnectionAttach" {
  policy_arn = aws_iam_policy.CodeStarConnectionPolicy.arn
  role       = aws_iam_role.PipelineRole.id
}
data "aws_iam_policy" "CodePipelineFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "PolicyAttach" {
  policy_arn = data.aws_iam_policy.CodePipelineFullAccess.arn
  role       = aws_iam_role.PipelineRole.name
}

## IAM role for the CodeBuild
resource "aws_iam_role" "CodeBuildRole" {
   name = "CodeBuildRole"
   assume_role_policy =  <<EOF
{
  "Version" : "2012-10-17",
  "Statement" :
  [
    {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : ["codebuild.amazonaws.com"]
      },
      "Action" : "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy" "CodeBuildDevAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy_attachment" "CodeBuildPolicyAttach" {
  policy_arn = data.aws_iam_policy.CodeBuildDevAccess.arn
  role       = aws_iam_role.CodeBuildRole.name
}

