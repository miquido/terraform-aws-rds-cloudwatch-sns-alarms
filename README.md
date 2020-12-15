<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->
[![Miquido][logo]](https://www.miquido.com/)

# miquido-terraform-aws-rds-cloudwatch-sns-alarms


Terraform module that configures important RDS alerts using CloudWatch and sends them to an SNS topic.

Create a set of sane RDS CloudWatch alerts for monitoring the health of an RDS instance.

### Open source modules used:
* https://github.com/cloudposse/terraform-aws-rds-cloudwatch-sns-alarms
---
**Terraform Module**
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
| terraform | >= 0.13 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | List of attributes to add to label. | `list(string)` | `[]` | no |
| burst\_balance\_threshold | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | `string` | `20` | no |
| cpu\_credit\_balance\_threshold | The minimum number of CPU credits (t2 instances only) available. | `string` | `20` | no |
| cpu\_utilization\_threshold | The maximum percentage of CPU utilization. | `string` | `80` | no |
| db\_instance\_id | The instance ID of the RDS database instance that you want to monitor. | `string` | n/a | yes |
| delimiter | The delimiter to be used in labels. | `string` | `"-"` | no |
| disk\_queue\_depth\_threshold | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | `string` | `64` | no |
| free\_storage\_space\_threshold | The minimum amount of available storage space in Byte. | `string` | `2000000000` | no |
| freeable\_memory\_threshold | The minimum amount of available random access memory in Byte. | `string` | `64000000` | no |
| name | Name (unique identifier for app or service) | `string` | n/a | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | `string` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| swap\_usage\_threshold | The maximum amount of swap space used on the DB instance in Byte. | `string` | `256000000` | no |
| tags | Map of key-value pairs to use for tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns\_topic\_arn | The ARN of the SNS topic |

<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint Terraform code

```
<!-- markdownlint-restore -->


## Developing

1. Make changes in terraform files

2. Regenerate documentation

    ```bash
    bash <(curl -s https://terraform.s3.k.miquido.net/update.sh)
    ```

3. Run lint

    ```
    make lint
    ```

## Copyright

Copyright © 2017-2020 [Miquido](https://miquido.com)



### Contributors

|  [![Jamie Nelson][Jamie-BitFlight_avatar]][Jamie-BitFlight_homepage]<br/>[Jamie Nelson][Jamie-BitFlight_homepage] | [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] |
|---|---|

  [Jamie-BitFlight_homepage]: https://github.com/Jamie-BitFlight
  [Jamie-BitFlight_avatar]: https://github.com/Jamie-BitFlight.png?size=150
  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://github.com/osterman.png?size=150



  [logo]: https://www.miquido.com/img/logos/logo__miquido.svg
  [website]: https://www.miquido.com/
  [gitlab]: https://gitlab.com/miquido
  [github]: https://github.com/miquido
  [bitbucket]: https://bitbucket.org/miquido

