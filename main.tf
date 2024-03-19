data "aws_caller_identity" "default" {}

locals {
  sns_alarm_topic_arn = var.sns_alarm_topic_arn == null ? aws_sns_topic.alarm[0].arn : var.sns_alarm_topic_arn
  sns_ok_topic_arn    = var.sns_ok_topic_arn == null ? aws_sns_topic.ok[0].arn : var.sns_ok_topic_arn
}

module "sns_topic_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.8.0"
  name       = "${var.name}-alarm"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["rds", "threshold", "alerts"]))
  tags       = var.tags
}

module "sns_topic_ok_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.8.0"
  name       = "${var.name}-ok"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["rds", "threshold", "alerts"]))
  tags       = var.tags
}

resource "aws_sns_topic" "alarm" {
  count       = var.sns_alarm_topic_arn == null ? 1 : 0
  name_prefix = module.sns_topic_alarm_label.id
  tags        = module.sns_topic_alarm_label.tags
}

resource "aws_sns_topic" "ok" {
  count       = var.sns_ok_topic_arn == null ? 1 : 0
  name_prefix = module.sns_topic_ok_label.id
  tags        = module.sns_topic_ok_label.tags
}

module "db_event_subscription_default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.8.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["rds", "event", "sub"]))
  tags       = var.tags
}

resource "aws_db_event_subscription" "default" {
  name_prefix = module.db_event_subscription_default_label.id
  sns_topic   = local.sns_alarm_topic_arn
  source_type = "db-instance"
  source_ids  = [var.db_instance_id]
  tags        = module.db_event_subscription_default_label.tags

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

}

resource "aws_sns_topic_policy" "alarm" {
  count  = var.sns_alarm_topic_arn == null ? 1 : 0
  arn    = aws_sns_topic.alarm[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[local.sns_alarm_topic_arn].json
}

resource "aws_sns_topic_policy" "ok" {
  count  = var.sns_ok_topic_arn == null ? 1 : 0
  arn    = aws_sns_topic.ok[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[local.sns_ok_topic_arn].json
}

locals {
  topics = toset([local.sns_ok_topic_arn, local.sns_alarm_topic_arn])
}

data "aws_iam_policy_document" "sns_topic_policy" {
  for_each = local.topics
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"
    resources = [
      each.value
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.default.account_id,
      ]
    }
  }

  statement {
    sid     = "Allow CloudwatchEvents"
    actions = ["sns:Publish"]
    resources = [
      each.value
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid     = "Allow RDS Event Notification"
    actions = ["sns:Publish"]
    resources = [
      each.value
    ]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
