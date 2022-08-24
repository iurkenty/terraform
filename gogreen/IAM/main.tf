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
