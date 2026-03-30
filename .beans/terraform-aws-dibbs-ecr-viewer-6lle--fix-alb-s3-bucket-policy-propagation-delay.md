---
# terraform-aws-dibbs-ecr-viewer-6lle
title: Fix ALB S3 bucket policy propagation delay
status: in-progress
type: bug
priority: normal
created_at: 2026-03-30T22:20:15Z
updated_at: 2026-03-30T22:21:38Z
---

The ALB creation fails with 'Access Denied' when trying to write to the logging bucket. The S3 bucket policy is updated but not fully propagated before the ALB tries to use it.

## Plan

1. Add a `time_sleep` resource to wait for S3 bucket policy propagation before ALB creation
2. Update alb.tf to depend on the time_sleep resource

## Implementation

1. Added `time_sleep` resource in `s3.tf` that waits 10 seconds after the S3 bucket policy is created/updated
2. Added `time` provider to `provider.tf`
3. Updated `alb.tf` to depend on the `time_sleep` resource

The `time_sleep` resource ensures the S3 bucket policy has enough time to propagate before the ALB tries to use it for access logs.

## Summary of Changes

- **s3.tf**: Added `time_sleep.wait_for_s3_bucket_policy` resource that creates a 10-second delay after the S3 bucket policy is updated
- **provider.tf**: Added `time` provider (hashicorp/time, ~> 0.13.1) required for the sleep resource
- **alb.tf**: Added `time_sleep.wait_for_s3_bucket_policy` to the `depends_on` list to ensure the ALB is only created after the policy has propagated

## Reasons for Scrapping

(none - fix in progress)
