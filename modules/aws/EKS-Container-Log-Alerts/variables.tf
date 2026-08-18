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
variable "pod_name" {
  type        = string
  description = "Name of the pod"
}
variable "namespace" {
  type        = string
  description = "Namespace which contains the container"
}
variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
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
variable "info_alarm_actions" {
  type        = list(string)
  description = "The ARNs of the actions to take when the alarm changes state to info"
  default     = []
}
variable "enable_alarm_actions" {
  type        = bool
  description = "Whether alarms actively notify (actions_enabled). Set false to create the alarms without them paging anyone yet."
  default     = true
}
variable "container_log_alerts" {
  type = map(object({
    priority            = string
    comparison_operator = string
    evaluation_periods  = number
    time_window         = number
    enabled             = optional(bool, true)
    log_entry           = string
    log_summary         = string
    threshold           = number
    k8s_container_name  = string
  }))
  description = "Container log alerts, evaluated against CloudWatch Logs metric filters"
  default     = {}
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
