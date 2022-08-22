provider "aws" {
  region = "us-west-2"
}
//noinspection MissingModule
module "SysAdmin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name = var.sysadmin[count.index]
  count = length(var.sysadmin)

  create_iam_user_login_profile = false
  create_iam_access_key = false
}

//noinspection MissingModule
module "DBadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name = var.dbadmin[count.index]
  count = length(var.dbadmin)

}