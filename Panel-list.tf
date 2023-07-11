terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 1.41.0"
    }
  }
}

provider "grafana" {
  # Grafana authentication token
  auth = "eyJrIjoibXVMTFg3b3NSNnhJOVZuYVVHbHhYYTN6cHJZNnVPcnQiLCJuIjoiZ3JhZmFuYSIsImlkIjoxfQ=="
  # Grafana URL
  url  = "https://g-ebbc3b012b.grafana-workspace.us-east-1.amazonaws.com/?orgId=1"
}

variable "dashboard_title" {
  type = string
}

variable "metric_name" {
  description = "Name of the metric"
  type        = string
}

variable "region" {
  description = "Region for the panel"
  type        = string
}

variable "statistic" {
  description = "Statistic for the panel"
  type        = string
}

variable "number_of_panels" {
  type = number
}

resource "grafana_dashboard" "example" {
  org_id       = 1
  config_json  = jsonencode({
    title  = var.dashboard_title
    panels = [
      for i in range(var.number_of_panels) : {
        id         = "panel-${i}"
        title      = "Panel ${i}"
        gridPos    = {
          x = 0
          y = 5
          w = 6
          h = 6
        }
        datasource = "your-datasource"
        options    = {
          legend = {
            calcs     = ["sum"]
            placement = "right"
            showLegend = true
          }
          tooltip = {
            mode = "single"
            sort = "ascending"
          }
        }
        targets = [
          {
            alias             = "Target ${i}"
            datasource        = "your-datasource"
            dimensions        = {}
            expression        = "your-expression"
            id                = "target-${i}"
            matchExact        = true
            metricEditorMode  = 1
            metricName        = var.metric_name
            metricQueryType   = 1
            namespace         = ""
            period            = ""
            queryMode         = "metric"
            refId             = "A"
            region            = var.region
            sqlExpression     = ""
            statistic         = var.statistic
          }
        ]
        type = "graph"
      }
    ]
  })
}

resource "local_file" "dashboard_name" {
  content     = var.dashboard_title
  filename    = "dashboard_name.txt"
}

output "dashboard_name" {
  value = local_file.dashboard_name.content
}