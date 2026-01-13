# Table of Contents
[1. Overview](#1-overview)
[2. Notices](#2-notices)
- [Table of Contents](#table-of-contents)
- [1. Overview](#1-overview)
- [2. Notices](#2-notices)
  - [2.1 Public Domain Standard Notice](#21-public-domain-standard-notice)
  - [2.2 License Standard Notice](#22-license-standard-notice)
  - [2.3 Privacy Standard Notice](#23-privacy-standard-notice)
  - [2.4 Contributing Standard Notice](#24-contributing-standard-notice)
  - [2.5 Records Management Standard Notice](#25-records-management-standard-notice)
  - [2.6 Additional Standard Notices](#26-additional-standard-notices)
- [3. Architectural Design](#3-architectural-design)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

# 1. Overview

The Data Integration Building Blocks (DIBBs) project is an effort to help state, local, territorial, and tribal public health departments better make sense of and utilize their data. You can read more about the project on the [main DIBBs repository](https://github.com/CDCgov/phdi/blob/main/README.md).

This repository is specifically to develop an AWS "starter kit" for the DIBBs project. This will enable our jurisdictional partners to build from this repository to provision their own AWS infrastructure.

+ [Return to Table of Contents](#table-of-contents).

# 2. Notices
## 2.1 Public Domain Standard Notice
This repository constitutes a work of the United States Government and is not
subject to domestic copyright protection under 17 USC § 105. This repository is in
the public domain within the United States, and copyright and related rights in
the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
All contributions to this repository will be released under the CC0 dedication. By
submitting a pull request you are agreeing to comply with this waiver of
copyright interest.


+ [Return to Table of Contents](#table-of-contents).

## 2.2 License Standard Notice
The repository utilizes code licensed under the terms of the Apache Software
License and therefore is licensed under ASL v2 or later.

This source code in this repository is free: you can redistribute it and/or modify it under
the terms of the Apache Software License version 2, or (at your option) any
later version.

This source code in this repository is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the Apache Software License for more details.

You should have received a copy of the Apache Software License along with this
program. If not, see http://www.apache.org/licenses/LICENSE-2.0.html.

The source code forked from other open source projects will inherit its license.


+ [Return to Table of Contents](#table-of-contents).

## 2.3 Privacy Standard Notice
This repository contains only non-sensitive, publicly available data and
information. All material and community participation is covered by the
[Disclaimer](DISCLAIMER.md)
and [Code of Conduct](code-of-conduct.md).
For more information about CDC's privacy policy, please visit [http://www.cdc.gov/other/privacy.html](https://www.cdc.gov/other/privacy.html).


+ [Return to Table of Contents](#table-of-contents).

## 2.4 Contributing Standard Notice
Anyone is encouraged to contribute to the repository by [forking](https://help.github.com/articles/fork-a-repo)
and submitting a pull request. (If you are new to GitHub, you might start with a [basic tutorial](https://help.github.com/articles/set-up-git).) By contributing to this project, you grant a world-wide, royalty-free, perpetual, irrevocable, non-exclusive, transferable license to all users under the terms of the [Apache Software License v2](http://www.apache.org/licenses/LICENSE-2.0.html) or later.

All comments, messages, pull requests, and other submissions received through
CDC including this GitHub page may be subject to applicable federal law, including but not limited to the Federal Records Act, and may be archived. Learn more at [http://www.cdc.gov/other/privacy.html](http://www.cdc.gov/other/privacy.html).


+ [Return to Table of Contents](#table-of-contents).

## 2.5 Records Management Standard Notice
This repository is not a source of government records, but is a copy to increase collaboration and collaborative potential. All government records will be published through the [CDC web site](http://www.cdc.gov).

+ [Return to Table of Contents](#table-of-contents).

## 2.6 Additional Standard Notices
Please refer to [CDC's Template Repository](https://github.com/CDCgov/template) for more information about [contributing to this repository](https://github.com/CDCgov/template/blob/main/CONTRIBUTING.md), [public domain notices and disclaimers](https://github.com/CDCgov/template/blob/main/DISCLAIMER.md), and [code of conduct](https://github.com/CDCgov/template/blob/main/code-of-conduct.md).


+ [Return to Table of Contents](#table-of-contents).

# 3. Architectural Design
The current architectural design for dibbs-aws is as follows:

![Current DIBBS Architecture as of 6-24-2024](https://github.com/CDCgov/dibbs-aws/assets/29112142/7d43d3c1-5d61-41b8-a1c3-bb4884073825)

+ [Return to Table of Contents](#table-of-contents).
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.86.0 |
| <a name="requirement_dockerless"></a> [dockerless](#requirement\_dockerless) | ~> 0.1.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.86.1 |
| <a name="provider_aws.replication"></a> [aws.replication](#provider\_aws.replication) | 5.86.1 |
| <a name="provider_dockerless"></a> [dockerless](#provider\_dockerless) | 0.1.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener_rule.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_listener_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appautoscaling_policy.cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appmesh_mesh.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_mesh) | resource |
| [aws_appmesh_virtual_node.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_node) | resource |
| [aws_cloudwatch_log_group.ecs_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.dibbs_app_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_flow_log.ecs_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.s3_bucket_ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.s3_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.s3_role_for_ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.ecr_viewer_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.ecr_viewer_s3_access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.logging_s3_access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_object_lock_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_policy.ecr_viewer_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.ecr_viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.ecr_viewer_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_alb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_all_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_ecs_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_service_discovery_private_dns_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_vpc_endpoint.endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [dockerless_remote_image.dibbs](https://registry.terraform.io/providers/nullstone-io/dockerless/latest/docs/resources/remote_image) | resource |
| [null_resource.target_groups](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.s3_viewer](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_ecr_lifecycle_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_lifecycle_policy_document) | data source |
| [aws_elb_service_account.elb_account_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy.amazon_ec2_container_service_for_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecr_viewer_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecr_viewer_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_idle_timeout"></a> [alb\_idle\_timeout](#input\_alb\_idle\_timeout) | The idle timeout value in seconds for the Application Load Balancer (ALB) | `number` | `900` | no |
| <a name="input_appmesh_name"></a> [appmesh\_name](#input\_appmesh\_name) | Name of the AWS App Mesh | `string` | `""` | no |
| <a name="input_auth_client_id"></a> [auth\_client\_id](#input\_auth\_client\_id) | The application/client id used to idenitfy the client | `string` | `""` | no |
| <a name="input_auth_issuer"></a> [auth\_issuer](#input\_auth\_issuer) | Additional information used during authentication process. For Azure AD, this will be the 'Tenant Id'. For Keycloak, this will be the url issuer including the realm - e.g. https://my-keycloak-domain.com/realms/My_Realm | `string` | `""` | no |
| <a name="input_auth_provider"></a> [auth\_provider](#input\_auth\_provider) | The authentication provider used. Either keycloak or ad. | `string` | `""` | no |
| <a name="input_auth_session_duration_min"></a> [auth\_session\_duration\_min](#input\_auth\_session\_duration\_min) | Duration in minutes before auto signout, defaults to 30 if not set | `string` | `""` | no |
| <a name="input_auth_url"></a> [auth\_url](#input\_auth\_url) | Optional. The full URL of the auth api. By default https://your-site.com/ecr-viewer/api/auth. | `string` | `""` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL certificate that enables ssl termination on the ALB | `string` | `""` | no |
| <a name="input_cloudmap_namespace_name"></a> [cloudmap\_namespace\_name](#input\_cloudmap\_namespace\_name) | Name of the AWS Cloud Map namespace | `string` | `""` | no |
| <a name="input_cw_retention_in_days"></a> [cw\_retention\_in\_days](#input\_cw\_retention\_in\_days) | Retention period in days for CloudWatch logs | `number` | `365` | no |
| <a name="input_db_cipher"></a> [db\_cipher](#input\_db\_cipher) | The cipher to use for the sql server database connection | `string` | `""` | no |
| <a name="input_dibbs_config_name"></a> [dibbs\_config\_name](#input\_dibbs\_config\_name) | Name of the DIBBS configuration | `string` | `""` | no |
| <a name="input_dibbs_repo"></a> [dibbs\_repo](#input\_dibbs\_repo) | Name of the DIBBS repository | `string` | `"ghcr.io/cdcgov/dibbs-ecr-viewer"` | no |
| <a name="input_disable_ecr"></a> [disable\_ecr](#input\_disable\_ecr) | Flag to disable the aws ecr service for docker image storage, defaults to false | `bool` | `false` | no |
| <a name="input_ecr_viewer_auth_api_pub_key"></a> [ecr\_viewer\_auth\_api\_pub\_key](#input\_ecr\_viewer\_auth\_api\_pub\_key) | The public key used to validate the incoming authenication for the eCR Viewer API. | `string` | `""` | no |
| <a name="input_ecr_viewer_auth_pub_key"></a> [ecr\_viewer\_auth\_pub\_key](#input\_ecr\_viewer\_auth\_pub\_key) | The public key used to validate the incoming authenication for the eCR Viewer. | `string` | `""` | no |
| <a name="input_ecr_viewer_object_retention_days"></a> [ecr\_viewer\_object\_retention\_days](#input\_ecr\_viewer\_object\_retention\_days) | Number of days to retain S3 ecr viewer objects in compliance mode | `number` | `3650` | no |
| <a name="input_ecs_alb_name"></a> [ecs\_alb\_name](#input\_ecs\_alb\_name) | Name of the Application Load Balancer (ALB) | `string` | `""` | no |
| <a name="input_ecs_alb_tg_name"></a> [ecs\_alb\_tg\_name](#input\_ecs\_alb\_tg\_name) | Name of the ALB Target Group | `string` | `""` | no |
| <a name="input_ecs_cloudwatch_group"></a> [ecs\_cloudwatch\_group](#input\_ecs\_cloudwatch\_group) | Name of the AWS CloudWatch Log Group for ECS | `string` | `""` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS Cluster | `string` | `""` | no |
| <a name="input_ecs_task_execution_role_name"></a> [ecs\_task\_execution\_role\_name](#input\_ecs\_task\_execution\_role\_name) | Name of the ECS Task Execution Role | `string` | `""` | no |
| <a name="input_ecs_task_role_name"></a> [ecs\_task\_role\_name](#input\_ecs\_task\_role\_name) | Name of the ECS Task Role | `string` | `""` | no |
| <a name="input_enable_alb_deletion_protection"></a> [enable\_alb\_deletion\_protection](#input\_enable\_alb\_deletion\_protection) | Flag to enable ALB deletion protection | `bool` | `true` | no |
| <a name="input_enable_alb_logs"></a> [enable\_alb\_logs](#input\_enable\_alb\_logs) | Flag to enable ALB access and connection logging to s3 logging bucket | `bool` | `true` | no |
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | Flag to enable autoscaling for the ECS services | `bool` | `true` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Flag to determine if the several AWS resources are public (intended for external access, public internet) or private (only intended to be accessed within your AWS VPC or avaiable with other means, a transit gateway for example). | `bool` | `true` | no |
| <a name="input_logging_object_retention_days"></a> [logging\_object\_retention\_days](#input\_logging\_object\_retention\_days) | Number of days to retain S3 logging objects in compliance mode | `number` | `90` | no |
| <a name="input_override_autoscaling"></a> [override\_autoscaling](#input\_override\_autoscaling) | Autoscaling configuration for the DIBBS services | <pre>map(object({<br>    cpu           = number<br>    memory        = number<br>    min_capacity  = number<br>    max_capacity  = number<br>    target_cpu    = number<br>    target_memory = number<br>  }))</pre> | `{}` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the resources | `string` | `"CDC"` | no |
| <a name="input_phdi_version"></a> [phdi\_version](#input\_phdi\_version) | Version of the PHDI application | `string` | `"v2.0.0-beta"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | `"dibbs"` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources are created | `string` | n/a | yes |
| <a name="input_replication_region"></a> [replication\_region](#input\_replication\_region) | The AWS region where S3 bucket replication destination is located | `string` | n/a | yes |
| <a name="input_s3_logging_bucket_name"></a> [s3\_logging\_bucket\_name](#input\_s3\_logging\_bucket\_name) | Name of the S3 bucket for logging | `string` | `""` | no |
| <a name="input_s3_viewer_bucket_name"></a> [s3\_viewer\_bucket\_name](#input\_s3\_viewer\_bucket\_name) | Name of the S3 bucket for the viewer | `string` | `""` | no |
| <a name="input_s3_viewer_bucket_role_name"></a> [s3\_viewer\_bucket\_role\_name](#input\_s3\_viewer\_bucket\_role\_name) | Name of the IAM role for the ecr-viewer bucket | `string` | `""` | no |
| <a name="input_secrets_manager_auth_client_secret_version"></a> [secrets\_manager\_auth\_client\_secret\_version](#input\_secrets\_manager\_auth\_client\_secret\_version) | The secret containing the auth client secret. This is the secret that comes from the authentication provider. | `string` | `""` | no |
| <a name="input_secrets_manager_auth_secret_version"></a> [secrets\_manager\_auth\_secret\_version](#input\_secrets\_manager\_auth\_secret\_version) | The secret containing the auth secret. This is used by eCR viewer to encrypt authentication. This can be generated by running `openssl rand -base64 32`. | `string` | `""` | no |
| <a name="input_secrets_manager_connection_string_version"></a> [secrets\_manager\_connection\_string\_version](#input\_secrets\_manager\_connection\_string\_version) | n/a | `string` | `""` | no |
| <a name="input_secrets_manager_metadata_database_migration_secret_version"></a> [secrets\_manager\_metadata\_database\_migration\_secret\_version](#input\_secrets\_manager\_metadata\_database\_migration\_secret\_version) | n/a | `string` | `""` | no |
| <a name="input_secrets_manager_sqlserver_host_version"></a> [secrets\_manager\_sqlserver\_host\_version](#input\_secrets\_manager\_sqlserver\_host\_version) | n/a | `string` | `""` | no |
| <a name="input_secrets_manager_sqlserver_password_version"></a> [secrets\_manager\_sqlserver\_password\_version](#input\_secrets\_manager\_sqlserver\_password\_version) | n/a | `string` | `""` | no |
| <a name="input_secrets_manager_sqlserver_user_version"></a> [secrets\_manager\_sqlserver\_user\_version](#input\_secrets\_manager\_sqlserver\_user\_version) | n/a | `string` | `""` | no |
| <a name="input_service_data"></a> [service\_data](#input\_service\_data) | Data for the DIBBS services | <pre>map(object({<br>    short_name        = string<br>    app_repo          = string<br>    app_image         = string<br>    app_version       = string<br>    container_port    = number<br>    host_port         = number<br>    public            = bool<br>    registry_url      = string<br>    root_service      = bool<br>    listener_priority = number<br>    env_vars = list(object({<br>      name  = string<br>      value = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | n/a |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_alb_listener_arn"></a> [alb\_listener\_arn](#output\_alb\_listener\_arn) | n/a |
| <a name="output_alb_security_group_arn"></a> [alb\_security\_group\_arn](#output\_alb\_security\_group\_arn) | n/a |
| <a name="output_alb_target_groups_arns"></a> [alb\_target\_groups\_arns](#output\_alb\_target\_groups\_arns) | n/a |
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | n/a |
| <a name="output_ecs_security_group_arn"></a> [ecs\_security\_group\_arn](#output\_ecs\_security\_group\_arn) | n/a |
| <a name="output_ecs_task_definitions_arns"></a> [ecs\_task\_definitions\_arns](#output\_ecs\_task\_definitions\_arns) | n/a |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | n/a |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | n/a |
| <a name="output_http_alb_listener_rules_arns"></a> [http\_alb\_listener\_rules\_arns](#output\_http\_alb\_listener\_rules\_arns) | n/a |
| <a name="output_https_alb_listener_rules_arns"></a> [https\_alb\_listener\_rules\_arns](#output\_https\_alb\_listener\_rules\_arns) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_s3_bucket_ecr_viewer_policy_arn"></a> [s3\_bucket\_ecr\_viewer\_policy\_arn](#output\_s3\_bucket\_ecr\_viewer\_policy\_arn) | n/a |
| <a name="output_s3_role_for_ecr_viewer_arn"></a> [s3\_role\_for\_ecr\_viewer\_arn](#output\_s3\_role\_for\_ecr\_viewer\_arn) | n/a |
| <a name="output_service_data"></a> [service\_data](#output\_service\_data) | n/a |
<!-- END_TF_DOCS -->
