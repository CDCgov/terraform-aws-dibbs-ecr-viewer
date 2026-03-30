---
# terraform-aws-dibbs-ecr-viewer-6lle
title: Fix ALB S3 bucket policy propagation delay
status: in-progress
type: bug
priority: normal
created_at: 2026-03-30T22:20:15Z
updated_at: 2026-03-30T22:38:00Z
---

The ALB creation fails with 'Access Denied' when trying to write to the logging bucket. The S3 bucket policy was using service principals (elasticloadbalancing.amazonaws.com) which are not supported in S3 bucket policies - only AWS account principals work.

## Root Cause

S3 bucket policies **do not support service principals** like `elasticloadbalancing.amazonaws.com`. These only work with resource-based policies that explicitly support them (SQS, SNS, Lambda). For S3, you must use the account-specific ELB service account ARN.

The original policy had two statements with service principals:
1. `AWSLogDeliveryWrite` - used `elasticloadbalancing.amazonaws.com` service principal (ignored by S3)
2. `AWSLogDeliveryAclCheck` - used `elasticloadbalancing.amazonaws.com` service principal (ignored by S3)

The fix removes these invalid statements and keeps only the `AllowALBAccess` statement that uses the account-specific ELB service account ARN from `data.aws_elb_service_account.elb_account_id.arn`.

Also updated `AWSLogDeliveryAclCheck` to use the account-based principal instead of service principal.

## Implementation

1. Updated `_data.tf` `s3_logging` policy document to remove service principal statements
2. Changed `AWSLogDeliveryAclCheck` to use `AWS` type with ELB service account ARN

## Summary of Changes

- **_data.tf**: Removed `AWSLogDeliveryWrite` statement (service principal not supported in S3)
- **_data.tf**: Changed `AWSLogDeliveryAclCheck` to use `AWS` type with ELB service account ARN

## Reasons for Scrapping

(none - fix in progress)
