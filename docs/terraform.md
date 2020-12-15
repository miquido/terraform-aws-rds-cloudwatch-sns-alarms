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
