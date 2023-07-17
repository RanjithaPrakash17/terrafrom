terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">=1.41.0"
    }
  }
}

provider "grafana" {
  # Grafana authentication token
  auth = "eyJrIjoiUjliSmZ6ZnFJZnN4c2Qzdnk1Smx2NXR1VDRmNmVxNDYiLCJuIjoiZ3JhZmFuYSIsImlkIjoxfQ=="
  # Grafana URL
  url  = "https://g-ebbc3b012b.grafana-workspace.us-east-1.amazonaws.com/?orgId=1"
}

variable "dashboard_title" {
  description = "Title of the dashboard"
  type        = string
  default     = "DASHBOARD"
}

variable "panels" {
  description = "Panel configurations"
  type        = list(object({
    id          = number
    type        = string
    title       = string
    datasource  = string
    namespace   = string
    metric_name = string
    dimensions  = map(string)
    period      = number
    stat        = string
    region      = string
  }))
  default = [
    {
      id           = 1
      type         = "graph"
      title        = "EC2 Panel"
      datasource   = "Amazon CloudWatch us-east-1"
      namespace    = "AWS/EC2"
      metric_name  = "CPUUtilization"
      dimensions   = { InstanceId = "i-0f81733e20157863c" }
      period       = 300
      stat         = "Average"
      region       = "us-east-1"
    }
  ]
}

resource "grafana_dashboard" "simple" {
  config_json = <<EOT
{
  "title": "${var.dashboard_title}",
  "panels": ${jsonencode(var.panels)}
}
EOT
}

