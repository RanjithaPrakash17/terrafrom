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

variable "panel_title" {
  description = "Title for the panel"
  type        = string
}

resource "grafana_dashboard" "example" {
  org_id       = 1
  config_json  = jsonencode({
    title  = var.dashboard_title
    panels = [
      {
        id         = "panel-1"
        title      = var.panel_title
        gridPos    = {
          x = 0
          y = 0
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
            alias             = "Target 1"
            datasource        = "your-datasource"
            dimensions        = {}
            expression        = "your-expression"
            id                = "target-1"
            matchExact        = true
            metricEditorMode  = 1
            metricName        = ""
            metricQueryType   = 1
            namespace         = ""
            period            = ""
            queryMode         = "metric"
            refId             = "A"
            region            = ""
            sqlExpression     = ""
            statistic         = ""
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
