<!-- markdownlint-disable -->
# miquido-terraform-aws-rds-cloudwatch-sns-alarms <a href="https://miquido.com"><img align="right" src="https://cdn.miquido.dev/miquido-logo.png" width="150" /></a>

<!-- markdownlint-restore -->

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `miquido/build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  **





-->

Terraform module that configures important RDS alerts using CloudWatch and sends them to an SNS topic.

Create a set of sane RDS CloudWatch alerts for monitoring the health of an RDS instance.

### Open source modules used:
* https://github.com/cloudposse/terraform-aws-rds-cloudwatch-sns-alarms






## Usage


| area    | metric           | comparison operator  | threshold | rationale                                                                                                                                                                                              |
|---------|------------------|----------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Storage | BurstBalance     | `<`                  | 20 %      | 20 % of credits allow you to burst for a few minutes which gives you enough time to a) fix the inefficiency, b) add capacity or c) switch to io1 storage type.                                         |
| Storage | DiskQueueDepth   | `>`                  | 64        | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Storage | FreeStorageSpace | `<`                  | 2 GB      | 2 GB usually provides enough time to a) fix why so much space is consumed or b) add capacity. You can also modify this value to 10% of your database capacity.                                         |
| CPU     | CPUUtilization   | `>`                  | 80 %      | Queuing theory tells us the latency increases exponentially with utilization. In practice, we see higher latency when utilization exceeds 80% and unacceptable high latency with utilization above 90% |
| CPU     | CPUCreditBalance | `<`                  | 20        | One credit equals 1 minute of 100% usage of a vCPU. 20 credits should give you enough time to a) fix the inefficiency, b) add capacity or c) don't use t2 type.                                        |
| Memory  | FreeableMemory   | `<`                  | 64 MB     | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Memory  | SwapUsage        | `>`                  | 256 MB    | Sometimes you can not entirely avoid swapping. But once the database accesses paged memory, it will slow down.                                                                                         |




## Examples


See the [`examples/`](examples/) directory for working examples.

```hcl
module "rds_instance" {
  source               = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=master"
  namespace            = "eg"
  stage                = "prod"
  name                 = "app"
  allocated_storage    = "5"
  storage_type         = "gp2"
  database_name        = "wordpress"
  database_user        = "admin"
  database_password    = "xxxxxxxxxxxx"
  database_port        = 3306
  db_parameter_group   = "mysql5.7"
  engine               = "mysql"
  engine_version       = "5.7.17"
  major_engine_version = "5.7"
  subnet_ids           = ["sb-xxxxxxxxx", "sb-xxxxxxxxx"]
  vpc_id               = "vpc-xxxxxxxx"
}

module "rds_alarms" {
  source         = "git::https://github.com/cloudposse/terraform-aws-rds-cloudwatch-sns-alarms.git?ref=master"
  db_instance_id = module.rds_instance.instance_id
}
```



<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_burst_balance_too_low_label"></a> [burst\_balance\_too\_low\_label](#module\_burst\_balance\_too\_low\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_cpu_credit_balance_too_low_label"></a> [cpu\_credit\_balance\_too\_low\_label](#module\_cpu\_credit\_balance\_too\_low\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_cpu_utilization_too_high_label"></a> [cpu\_utilization\_too\_high\_label](#module\_cpu\_utilization\_too\_high\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_db_event_subscription_default_label"></a> [db\_event\_subscription\_default\_label](#module\_db\_event\_subscription\_default\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_disk_queue_depth_too_high_label"></a> [disk\_queue\_depth\_too\_high\_label](#module\_disk\_queue\_depth\_too\_high\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_free_storage_space_too_low_label"></a> [free\_storage\_space\_too\_low\_label](#module\_free\_storage\_space\_too\_low\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_freeable_memory_too_low_label"></a> [freeable\_memory\_too\_low\_label](#module\_freeable\_memory\_too\_low\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_sns_topic_alarm_label"></a> [sns\_topic\_alarm\_label](#module\_sns\_topic\_alarm\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_sns_topic_ok_label"></a> [sns\_topic\_ok\_label](#module\_sns\_topic\_ok\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |
| <a name="module_swap_usage_too_high_label"></a> [swap\_usage\_too\_high\_label](#module\_swap\_usage\_too\_high\_label) | git::https://github.com/cloudposse/terraform-terraform-label.git | 0.8.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.burst_balance_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_credit_balance_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_queue_depth_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.swap_usage_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_event_subscription.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_sns_topic.alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.ok](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_policy.ok](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of attributes to add to label. | `list(string)` | `[]` | no |
| <a name="input_burst_balance_threshold"></a> [burst\_balance\_threshold](#input\_burst\_balance\_threshold) | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | `string` | `20` | no |
| <a name="input_cpu_credit_balance_threshold"></a> [cpu\_credit\_balance\_threshold](#input\_cpu\_credit\_balance\_threshold) | The minimum number of CPU credits (t2 instances only) available. | `string` | `20` | no |
| <a name="input_cpu_utilization_threshold"></a> [cpu\_utilization\_threshold](#input\_cpu\_utilization\_threshold) | The maximum percentage of CPU utilization. | `string` | `80` | no |
| <a name="input_db_instance_id"></a> [db\_instance\_id](#input\_db\_instance\_id) | The instance ID of the RDS database instance that you want to monitor. | `string` | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | The delimiter to be used in labels. | `string` | `"-"` | no |
| <a name="input_disk_queue_depth_threshold"></a> [disk\_queue\_depth\_threshold](#input\_disk\_queue\_depth\_threshold) | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | `string` | `64` | no |
| <a name="input_free_storage_space_threshold"></a> [free\_storage\_space\_threshold](#input\_free\_storage\_space\_threshold) | The minimum amount of available storage space in Byte. | `string` | `2000000000` | no |
| <a name="input_freeable_memory_threshold"></a> [freeable\_memory\_threshold](#input\_freeable\_memory\_threshold) | The minimum amount of available random access memory in Byte. | `string` | `64000000` | no |
| <a name="input_name"></a> [name](#input\_name) | Name (unique identifier for app or service) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (e.g. `cp` or `cloudposse`) | `string` | n/a | yes |
| <a name="input_sns_alarm_topic_arn"></a> [sns\_alarm\_topic\_arn](#input\_sns\_alarm\_topic\_arn) | Provide SNS topic arn where threshold alarms actions will be sent | `string` | `null` | no |
| <a name="input_sns_ok_topic_arn"></a> [sns\_ok\_topic\_arn](#input\_sns\_ok\_topic\_arn) | Provide SNS topic arn where threshold OK actions will be sent | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| <a name="input_swap_usage_threshold"></a> [swap\_usage\_threshold](#input\_swap\_usage\_threshold) | The maximum amount of swap space used on the DB instance in Byte. | `string` | `256000000` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of key-value pairs to use for tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_alarm_arn"></a> [sns\_alarm\_arn](#output\_sns\_alarm\_arn) | The ARN of the SNS topic |
| <a name="output_sns_ok_arn"></a> [sns\_ok\_arn](#output\_sns\_ok\_arn) | The ARN of the SNS topic |
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->


## Related Projects

Check out these related projects.



## License

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License"></a>

<details>
<summary>Preamble to the Apache License, Version 2.0</summary>
<br/>
<br/>



```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
</details>
