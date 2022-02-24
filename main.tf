provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
    bucket                               = "ps-tfstate-backend"
    
}

data "aws_iam_policy_document" "deny_delete_kms_keys" {
  statement {
    sid    = "DenyDeletingKMSKeys"
    effect = "Deny"
    actions = [
      "kms:ScheduleKeyDeletion",
      "kms:Delete*"
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:PrincipalOrgPaths"
      values   = ["o-ws0x6j8zjl/r-ltxy/ou-ltxy-lktwu4sn"]
    }
  }
}

data "aws_iam_policy_document" "deny_non_us_regions" {
  statement {
    sid    = "DenyNonUSRegions"
    effect = "Deny"
    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "awsbillingconsole:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values = [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2",
      ]
    }
  }
}

data "aws_iam_policy_document" "security_scp_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.deny_delete_kms_keys.json
  ]
}

resource "aws_organizations_policy" "security_scp" {
  name        = "SecuritySCP"
  description = "SCP to prevent disabling security controls"
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.security_scp_policy.json
}

resource "aws_organizations_policy_attachment" "security_scp_attachments" {
  for_each  = toset(["ou-ltxy-lktwu4sn","ou-ltxy-ngzx5yvt"])
  policy_id = aws_organizations_policy.security_scp.id
  target_id = each.value
}
