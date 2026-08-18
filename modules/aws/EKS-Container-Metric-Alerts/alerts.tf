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

module "container-pod-metric-alerts" {
  # Pinned git ref rather than a relative "../Metric-Alarm" path — see RDS-Aurora-Metric-Alerts/alerts.tf for why.
  source   = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Metric-Alarm?ref=v1.45.0"
  for_each = var.metric_pod_alerts

  alarm_actions             = each.value.priority == "Critical" ? var.critical_alarm_actions : each.value.priority == "Warning" ? var.warning_alarm_actions : var.info_alarm_actions
  alarm_description         = "[${upper(each.value.priority)}] ${each.value.statistic} ${replace(each.value.metric_name, "_", " ")} of the pod ${var.pod_name} in namespace ${var.namespace} in cluster ${var.cluster_name} ${each.value.comparison_operator} ${each.value.threshold} within last ${each.value.evaluation_periods} ${each.value.period} second periods"
  application               = var.application
  tags                      = var.default_tags
  project                   = var.project
  region                    = var.region
  metric_namespace          = local.eks_container_insights_metrics_namespace
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  environment               = var.environment

  comparison_operator = each.value.comparison_operator
  metric_name         = each.value.metric_name
  metric_usage_prefix = join("-", [var.namespace, var.pod_name, each.value.statistic, each.value.metric_name, lower(each.value.priority)])
  threshold           = each.value.threshold
  enabled             = var.enable_alarm_actions && each.value.enabled
  evaluation_periods  = each.value.evaluation_periods
  period              = each.value.period
  statistic           = each.value.statistic

  dimensions = {
    ClusterName = var.cluster_name
    PodName     = var.pod_name
    Namespace   = var.namespace
  }
}

module "container-service-metric-alerts" {
  source   = "git::https://github.com/wso2/aws-terraform-modules.git//modules/aws/Metric-Alarm?ref=v1.45.0"
  for_each = var.metric_service_alerts

  alarm_actions             = each.value.priority == "Critical" ? var.critical_alarm_actions : each.value.priority == "Warning" ? var.warning_alarm_actions : var.info_alarm_actions
  alarm_description         = "[${upper(each.value.priority)}] ${each.value.statistic} ${replace(each.value.metric_name, "_", " ")} of the service ${var.service_name} in namespace ${var.namespace} in cluster ${var.cluster_name} ${each.value.comparison_operator} ${each.value.threshold} within last ${each.value.evaluation_periods} ${each.value.period} second periods"
  application               = var.application
  tags                      = var.default_tags
  project                   = var.project
  region                    = var.region
  metric_namespace          = local.eks_container_insights_metrics_namespace
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  environment               = var.environment

  comparison_operator = each.value.comparison_operator
  metric_name         = each.value.metric_name
  metric_usage_prefix = join("-", [var.namespace, var.pod_name, each.value.statistic, each.value.metric_name, lower(each.value.priority)])
  threshold           = each.value.threshold
  enabled             = var.enable_alarm_actions && each.value.enabled
  evaluation_periods  = each.value.evaluation_periods
  period              = each.value.period
  statistic           = each.value.statistic

  dimensions = {
    ClusterName = var.cluster_name
    Service     = var.service_name
    Namespace   = var.namespace
  }
}
