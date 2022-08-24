provider "aws" {
  region = "us-west-2"
}
data "local_file" "sysadmin-keys-gogreen" {
  filename = "../public-sysadmin-keys-gogreen.gpg"
}

//noinspection MissingModule
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

//noinspection MissingModule
module "password-policy" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-account"
  count         = length(var.sysadmin)
  account_alias = element(var.account-alias, count.index)

  minimum_password_length      = 10
  require_numbers              = true
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_symbols              = true
  password_reuse_prevention    = 3
  max_password_age             = 90


}

 resource "aws_iam_group" "SysAdmin" {
  name = "SysAdmin"
}


  resource "aws_iam_group_membership" "SystemAdministration" {
  name  = "system-administration-team"
  users = [ module.SysAdmin[0].iam_user_name,
            module.SysAdmin[1].iam_user_name,
  ]
    group = aws_iam_group.SysAdmin.name
}

