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

module "rds-aurora-metric-alerts" {
  # Pinned git ref rather than a relative "../Metric-Alarm" path: this module is itself
  # consumed via a local absolute path (interim, not yet tagged) from the IAC repo, and
  # Terraform treats a local-path module source as its own "package" — a relative "../"
  # source inside it cannot escape that package. Once this module is tagged upstream, a
  # relative source would also work, but the git ref stays correct either way.
  source   = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Metric-Alarm?ref=v1.45.0"
  for_each = var.rds_alerts

  metric_namespace    = "AWS/RDS"
  metric_name         = each.value.metric_name
  alarm_description   = "[${upper(each.value.priority)}] ${each.value.statistic} ${each.value.metric_name} of Aurora cluster ${var.db_cluster_identifier} ${each.value.comparison_operator} ${each.value.threshold} within last ${each.value.evaluation_periods} ${each.value.period} second periods"
  alarm_actions       = each.value.priority == "Critical" ? var.critical_alarm_actions : var.warning_alarm_actions
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  metric_usage_prefix = join("-", [each.value.statistic, each.value.metric_name, lower(each.value.priority)])
  dimensions = {
    DBClusterIdentifier = var.db_cluster_identifier
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
