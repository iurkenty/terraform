output "iam_user_name" {
  description = "The user's name"
  value       = module.SysAdmin.*.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for.password-policy user"
  value       = module.SysAdmin.*.iam_user_arn
}

output "iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = module.SysAdmin.*.iam_user_unique_id
}

output "iam_user_login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value       = module.SysAdmin.*.iam_user_login_profile_key_fingerprint
}

output "iam_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.SysAdmin.*.iam_user_login_profile_encrypted_password
}

output "iam_user_login_profile_password" {
  description = "The user password"
  value       = module.SysAdmin.*.iam_user_login_profile_password
  sensitive   = true
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.SysAdmin.*.iam_access_key_id
}

output "iam_access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = module.SysAdmin.*.iam_access_key_key_fingerprint
}

output "iam_access_key_encrypted_secret" {
  description = "The encrypted secret, base64 encoded"
  value       = module.SysAdmin.*.iam_access_key_encrypted_secret
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = module.SysAdmin.*.iam_access_key_secret
  sensitive   = true
}

output "iam_access_key_ses_smtp_password_v4" {
  description = "The secret access key converted into an SES SMTP password"
  value       = module.SysAdmin.*.iam_access_key_ses_smtp_password_v4
  sensitive   = true
}

output "iam_access_key_status" {
  description = "Active or Inactive. Keys are initially active, but can be made inactive by other means."
  value       = module.SysAdmin.*.iam_access_key_status
}

output "pgp_key" {
  description = "PGP key used to encrypt sensitive data for.password-policy user (if empty - secrets are not encrypted)"
  value       = module.SysAdmin.*.pgp_key
}
/*
output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = module.SysAdmin.*.keybase_password_decrypt_command
}

output "keybase_password_pgp_message" {
  description = "Encrypted password"
  value       = module.SysAdmin.*.keybase_password_pgp_message
}

output "keybase_secret_key_decrypt_command" {
  description = "Decrypt access secret key command"
  value       = module.SysAdmin.*.keybase_secret_key_decrypt_command
}

output "keybase_secret_key_pgp_message" {
  description = "Encrypted access secret key"
  value       = module.SysAdmin.*.keybase_secret_key_pgp_message
}
*/

## Module.password-policy

output "caller_identity_account_id" {
  description = "The ID of the AWS account"
  value       = module.password-policy.*.caller_identity_account_id
}

output "iam_account_password_policy_expire_passwords" {
  description = "Indicates whether passwords in the account expire. Returns true if max_password_age contains a value greater than 0. Returns false if it is 0 or not present."
  value       = module.password-policy.*.iam_account_password_policy_expire_passwords
}

## Module iam-group-with-policies

output "iam_account_id" {
  description = "IAM AWS account id"
  value       = module.SysAdminGroupPolicy.aws_account_id
}

output "group_arn" {
  description = "IAM group arn"
  value       = module.SysAdminGroupPolicy.group_arn
}

output "group_users" {
  description = "List of IAM users in IAM group"
  value       = module.SysAdminGroupPolicy.group_users
}

output "group_name" {
  description = "IAM group name"
  value       = module.SysAdminGroupPolicy.group_name
}