# -------------------------------------------------------------------------------------
#
# Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

module "container-log-alerts" {
  # Pinned git ref rather than a relative "../Custom-AKS-Application-Log-Alarm" path — see
  # RDS-Aurora-Metric-Alerts/alerts.tf for why.
  source       = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Custom-AKS-Application-Log-Alarm?ref=v1.45.0"
  for_each     = var.container_log_alerts
  cluster_name = var.cluster_name
  namespace    = var.namespace
  application  = var.application
  environment  = var.environment
  pod_name     = var.pod_name
  project      = var.project
  region       = var.region

  # If priority is Critical then use critical_alarm_actions if Warning then use warning alarm actions if Info use info alarm actions
  alarm_actions             = each.value.priority == "Critical" ? var.critical_alarm_actions : each.value.priority == "Warning" ? var.warning_alarm_actions : var.info_alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  log_alarm_description     = "[${upper(each.value.priority)}] Number of \"${each.value.log_entry}\" log entries ${each.value.comparison_operator} ${each.value.threshold} in logs of ${each.value.k8s_container_name}  in pod ${var.pod_name} in namespace ${var.namespace} in cluster ${var.cluster_name} within last ${each.value.evaluation_periods} ${each.value.time_window} second periods"
  comparison_operator       = each.value.comparison_operator
  k8s_container_name        = each.value.k8s_container_name
  evaluation_periods        = each.value.evaluation_periods
  time_window               = each.value.time_window
  enabled                   = var.enable_alarm_actions && each.value.enabled
  log_entry                 = each.value.log_entry
  error_log_summary         = join("-", [var.namespace, var.pod_name, each.value.k8s_container_name, each.value.log_summary, (lower(each.value.priority))])
  threshold                 = each.value.threshold

  tags = var.default_tags
}
