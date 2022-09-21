provider "aws" {
  region = "us-west-2"
  alias = "primary-region"
}
provider "aws" {
  region = "us-west-1"
  alias = "bucket-region"
}

## Instance profile
resource "aws_s3control_multi_region_access_point" "utility-bucket-control" {
  details {
    name = "utility-bucket"
    region {
      bucket = data.aws_s3_bucket.gogreen-utility-bucket-iurkenty-arn.id
    }
  }
}

data "aws_s3_bucket" "gogreen-utility-bucket-iurkenty-arn" {
  provider = aws.bucket-region
  bucket = "gogreen-utility-bucket-iurkenty"
}
resource "aws_iam_policy" "EC2toS3Policy" {
  name        = "EC2toS3Policy"
  description = "Read-Write policy for EC2"
  policy      = data.aws_iam_policy_document.EC2toS3Policy.json
}
data "aws_iam_policy_document" "EC2toS3Policy" {
    statement  {

        actions = [
        "s3:*",
        "s3-object-lambda:*",
        ]
        resources = [
          data.aws_s3_bucket.gogreen-utility-bucket-iurkenty-arn.arn,
          "${data.aws_s3_bucket.gogreen-utility-bucket-iurkenty-arn.arn}/*"
     ]
    }
  }


resource "aws_iam_role" "EC2toS3IAMRole" {
  name               = "EC2toS3IAMRole"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" :
  [
    {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : ["ec2.amazonaws.com"]
      },
      "Action" : "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "EC2toS3FullAccess" {
  policy_arn = aws_iam_policy.EC2toS3Policy.arn
  role       = aws_iam_role.EC2toS3IAMRole.name
}
resource "aws_iam_instance_profile" "AppTierEC2Profile" {
  name = "AppTierEC2Profile"
  role = aws_iam_role.EC2toS3IAMRole.name
}

## Public Keys for all users
data "local_file" "sysadmin-keys-gogreen" {
  filename = "../public-sysadmin-keys-gogreen.gpg"
  }
data "local_file" "dbadmin-keys-gogreen" {
  filename = "../public-dbadmin-keys-gogreen.gpg"
}
data  "local_file" "monitor-users-keys-gogreen" {
  filename = "../public-monitor-users-keys-gogreen.gpg"
}


## System Administration with MFA enforced and SysAdmin policy
module "SysAdmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = element(var.sysadmin, count.index)
  count         = length(var.sysadmin)
  pgp_key       = data.local_file.sysadmin-keys-gogreen.content_base64
  force_destroy = true

  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = false
}
#################################
# - Future Use
# lifecycle {
#     ignore_changes = [password_reset_required]
#   }
#################################

module "SysAdminGroupPolicy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name                                   = "SysAdmin"
  group_users                            = [module.SysAdmin[0].iam_user_name,
                                            module.SysAdmin[1].iam_user_name,
  ]
  custom_group_policy_arns               = [ "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  ]
  iam_self_management_policy_name_prefix = "IAMSelfManagement-SysAdminGroup"
}

module "enforce-mfa" {
  source  = "jeromegamez/enforce-mfa/aws"
  version = "2.0.0"

  groups = [module.SysAdminGroupPolicy.group_name,
            module.DBAdminGroupPolicy.group_name,
  ]
}


## Account Password policy
module "password-policy" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-account"
  count         = length(var.sysadmin)
  account_alias = "gogreen-project"

  minimum_password_length      = 10
  require_numbers              = true
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_symbols              = true
  password_reuse_prevention    = 3
  max_password_age             = 90

}

## Data-Base users with appropriate policies
module "DBadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = element(var.dbadmin, count.index)
  count         = length(var.dbadmin)
  pgp_key       = data.local_file.dbadmin-keys-gogreen.content_base64
  force_destroy = true

  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = true
}
############################
#  - Future Use
# lifecycle {
#     ignore_changes = [password_reset_required]
#   }
##################################

module "DBAdminGroupPolicy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name                                   = "DBAdmin"
  group_users                            = [module.DBadmin[0].iam_user_name,
                                            module.DBadmin[1].iam_user_name,
  ]
  custom_group_policy_arns               = [ "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
  ]
  iam_self_management_policy_name_prefix = "IAMSelfManagement-DBAdminGroup"
}
## Monitor-Users with appropriate policies and MonitorUserGroup
module "MonitorUser" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = element(var.monitoruser, count.index)
  count         = length(var.monitoruser)
  pgp_key       = data.local_file.monitor-users-keys-gogreen.content_base64
  force_destroy = true

  create_iam_user_login_profile = true
  create_iam_access_key         = true
  password_reset_required       = true
}
###########################
# - Future Use
#lifecycle {
#    ignore_changes = [password_reset_required]
#  }
#########################

module "MonitorUserGroupPolicy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name                                   = "MonitorGroup"
  group_users                            = [module.MonitorUser[0].iam_user_name,
                                            module.MonitorUser[1].iam_user_name,
  ]
  custom_group_policy_arns               = [ "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
  iam_self_management_policy_name_prefix = "IAMSelfManagement-MonitorGroup"
}
