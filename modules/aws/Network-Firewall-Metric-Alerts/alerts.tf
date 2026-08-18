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

module "network-firewall-metric-alerts" {
  # Pinned git ref rather than a relative "../Metric-Alarm" path — see RDS-Aurora-Metric-Alerts/alerts.tf for why.
  source   = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Metric-Alarm?ref=v1.45.0"
  for_each = var.firewall_alerts

  metric_namespace    = "AWS/NetworkFirewall"
  metric_name         = each.value.metric_name
  alarm_description   = "[${upper(each.value.priority)}] ${each.value.statistic} ${each.value.metric_name} of Network Firewall ${var.firewall_name} in ${var.availability_zone} ${each.value.comparison_operator} ${each.value.threshold} within last ${each.value.evaluation_periods} ${each.value.period} second periods"
  alarm_actions       = each.value.priority == "Critical" ? var.critical_alarm_actions : var.warning_alarm_actions
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  # availability_zone must be in the name — this module is called once per AZ, and without it
  # every AZ's alarm resolves to the same CloudWatch alarm name (last apply wins, silently
  # dropping the other AZs' alarms).
  metric_usage_prefix = join("-", [var.firewall_name, var.availability_zone, each.value.statistic, each.value.metric_name, lower(each.value.priority)])
  dimensions = {
    FirewallName     = var.firewall_name
    AvailabilityZone = var.availability_zone
    Engine           = each.value.engine
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
