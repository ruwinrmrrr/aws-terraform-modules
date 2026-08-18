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
variable "web_acl_name" {
  type        = string
  description = "Name of the WAF Web ACL (AWS/WAFV2 WebACL dimension)"
}
variable "waf_region" {
  type        = string
  description = "AWS/WAFV2 Region dimension value (use 'CloudFront' for a CLOUDFRONT-scoped Web ACL)"
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
variable "waf_alerts" {
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
  description = "AWS/WAFV2 metric alerts, evaluated across all rules (Rule=ALL). Count-based thresholds are generic starting points — tune per traffic baseline."
  default = {
    "blocked_requests_warning" = {
      threshold           = 500
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "BlockedRequests"
      priority            = "Warning"
    }
    "blocked_requests_critical" = {
      threshold           = 2000
      evaluation_periods  = 1
      period              = 300
      statistic           = "Sum"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      metric_name         = "BlockedRequests"
      priority            = "Critical"
    }
  }
}
