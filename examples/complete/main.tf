### For connecting and provisioning
variable "region" {
  default = "eu-west-2"
}

provider "aws" {
  region = var.region

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier_prefix    = "rds-server-example"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  apply_immediately    = "true"
  skip_final_snapshot  = "true"
}

module "rds_alarms" {
  source         = "../../"
  db_instance_id = aws_db_instance.default.id
  name           = "rds-alarms-simple"
  stage          = "dev"
  namespace      = "example"
}

output "rds_alarms_sns_alarm_topic_arn" {
  value = module.rds_alarms.sns_alarm_arn
}

output "rds_alarms_sns_ok_topic_arn" {
  value = module.rds_alarms.sns_ok_arn
}

output "rds_arn" {
  value = aws_db_instance.default.id
}
