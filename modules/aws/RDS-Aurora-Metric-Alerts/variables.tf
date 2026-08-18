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

variable "application" {
  type        = string
  description = "Purpose of the Monitors"
}
variable "project" {
  type        = string
  description = "Name of the project"
}
variable "environment" {
  type        = string
  description = "Name of the environment"
}
variable "region" {
  type        = string
  description = "Code of the region"
}
variable "default_tags" {
  type        = map(string)
  description = "Default tags to be applied to resources"
}
variable "db_cluster_identifier" {
  type        = string
  description = "Aurora DB cluster identifier the alarms are scoped to (AWS/RDS DBClusterIdentifier dimension)"
}
variable "critical_alarm_actions" {
  type        = list(string)
  description = "The ARNs of the actions to take when the alarm changes state to critical"
  default     = []
}
variable "warning_alarm_actions" {
  type        = list(string)
  description = "The ARNs of the actions to take when the alarm changes state to warning"
  default     = []
}
variable "ok_actions" {
  type        = list(string)
  description = "The ARNs of the actions to take when the alarm changes state to OK"
  default     = []
}
variable "insufficient_data_actions" {
  type        = list(string)
  description = "The ARNs of the actions to take when the alarm changes state to insufficient data"
  default     = []
}
variable "enable_alarm_actions" {
  type        = bool
  description = "Whether alarms actively notify (actions_enabled). Set false to create the alarms without them paging anyone yet."
  default     = true
}
variable "rds_alerts" {
  type = map(object({
    threshold           = number
    evaluation_periods  = number
    period              = number
    statistic           = string
    comparison_operator = string
    metric_name         = string
    priority            = string
    enabled             = optional(bool, true)
  }))
  description = "AWS/RDS metric alerts for the Aurora cluster. Byte/count thresholds (memory, connections, IOPS) are generic starting points — tune per instance class."
  default = {
    "cpu_utilization_warning" = {
      threshold           = 80
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "CPUUtilization"
      priority            = "Warning"
    }
    "cpu_utilization_critical" = {
      threshold           = 95
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "CPUUtilization"
      priority            = "Critical"
    }
    "freeable_memory_warning" = {
      threshold           = 524288000 # 500MB
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "LessThanOrEqualToThreshold"
      metric_name         = "FreeableMemory"
      priority            = "Warning"
    }
    "freeable_memory_critical" = {
      threshold           = 262144000 # 250MB
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "LessThanOrEqualToThreshold"
      metric_name         = "FreeableMemory"
      priority            = "Critical"
    }
    "database_connections_warning" = {
      threshold           = 800
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "DatabaseConnections"
      priority            = "Warning"
    }
    "database_connections_critical" = {
      threshold           = 1000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "DatabaseConnections"
      priority            = "Critical"
    }
    "read_iops_warning" = {
      threshold           = 8000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "ReadIOPS"
      priority            = "Warning"
    }
    "read_iops_critical" = {
      threshold           = 10000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "ReadIOPS"
      priority            = "Critical"
    }
    "write_iops_warning" = {
      threshold           = 8000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "WriteIOPS"
      priority            = "Warning"
    }
    "write_iops_critical" = {
      threshold           = 10000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Average"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "WriteIOPS"
      priority            = "Critical"
    }
  }
}
