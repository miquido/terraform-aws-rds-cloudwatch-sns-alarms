output "sns_alarm_arn" {
  description = "The ARN of the SNS topic"
  value       = local.sns_alarm_topic_arn
}

output "sns_ok_arn" {
  description = "The ARN of the SNS topic"
  value       = local.sns_alarm_topic_arn
}
