# -------------------------------------------------------------------------------------
#
# Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

module "waf-metric-alerts" {
  # Pinned git ref rather than a relative "../Metric-Alarm" path — see RDS-Aurora-Metric-Alerts/alerts.tf for why.
  source   = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Metric-Alarm?ref=v1.45.0"
  for_each = var.waf_alerts

  # A module block with for_each does not implicitly inherit a caller-aliased provider
  # (e.g. hub/core passing providers = { aws = aws.waf }) — must re-pass explicitly here too.
  providers = {
    aws = aws
  }

  metric_namespace    = "AWS/WAFV2"
  metric_name         = each.value.metric_name
  alarm_description   = "[${upper(each.value.priority)}] ${each.value.statistic} ${each.value.metric_name} of WAF Web ACL ${var.web_acl_name} ${each.value.comparison_operator} ${each.value.threshold} within last ${each.value.evaluation_periods} ${each.value.period} second periods"
  alarm_actions       = each.value.priority == "Critical" ? var.critical_alarm_actions : var.warning_alarm_actions
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  metric_usage_prefix = join("-", [var.web_acl_name, each.value.statistic, each.value.metric_name, lower(each.value.priority)])
  # CloudFront-scoped WAFv2 metrics carry no Region dimension at all — only regional Web ACLs do.
  dimensions = var.waf_region == "CloudFront" ? {
    WebACL = var.web_acl_name
    Rule   = "ALL"
    } : {
    WebACL = var.web_acl_name
    Rule   = "ALL"
    Region = var.waf_region
  }
  period                    = each.value.period
  evaluation_periods        = each.value.evaluation_periods
  statistic                 = each.value.statistic
  enabled                   = var.enable_alarm_actions && each.value.enabled
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  project                   = var.project
  environment               = var.environment
  region                    = var.region
  application               = var.application
  tags                      = var.default_tags
}
