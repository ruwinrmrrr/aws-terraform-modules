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
variable "firewall_name" {
  type        = string
  description = "Name of the AWS Network Firewall (AWS/NetworkFirewall FirewallName dimension)"
}
variable "availability_zone" {
  type        = string
  description = "Availability zone of the firewall endpoint (AWS/NetworkFirewall AvailabilityZone dimension)"
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
variable "firewall_alerts" {
  type = map(object({
    threshold           = number
    evaluation_periods  = number
    period              = number
    statistic           = string
    comparison_operator = string
    metric_name         = string
    # AWS/NetworkFirewall publishes every metric per-Engine (Stateless/Stateful/IPS) — the
    # dimension set must include it or the alarm never matches a published datapoint.
    engine   = string
    priority = string
    enabled  = optional(bool, true)
  }))
  description = "AWS/NetworkFirewall metric alerts. Count-based thresholds are generic starting points — tune per traffic baseline."
  default = {
    "dropped_packets_warning" = {
      threshold           = 1000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "DroppedPackets"
      engine              = "Stateful"
      priority            = "Warning"
    }
    "dropped_packets_critical" = {
      threshold           = 5000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "DroppedPackets"
      engine              = "Stateful"
      priority            = "Critical"
    }
    "invalid_dropped_packets_warning" = {
      threshold           = 1
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "InvalidDroppedPackets"
      engine              = "Stateless"
      priority            = "Warning"
    }
    "invalid_dropped_packets_critical" = {
      threshold           = 100
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "InvalidDroppedPackets"
      engine              = "Stateless"
      priority            = "Critical"
    }
  }
}
