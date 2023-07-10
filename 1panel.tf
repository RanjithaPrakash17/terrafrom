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
  type        = string
}

variable "panels" {
  description = "List of panels"
  type        = list(object({
    id         = string
    title      = string
    gridPos    = object({
      x = number
      y = number
      w = number
      h = number
    })
    datasource = string
    options    = object({
      legend = object({
        calcs     = list(string)
        placement = string
        showLegend = bool
      })
      tooltip = object({
        mode = string
        sort = string
      })
    })
    targets = list(object({
      alias             = string
      datasource        = string
      dimensions        = map(string)
      expression        = string
      id                = string
      matchExact        = bool
      metricEditorMode  = number
      metricName        = string
      metricQueryType   = number
      namespace         = string
      period            = string
      queryMode         = string
      refId             = string
      region            = string
      sqlExpression     = string
      statistic         = string
    }))
    type = string
  }))
  default = [
    {
      id         = "panel-1"
      title      = "Panel 1"
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
}

resource "grafana_dashboard" "example" {
  org_id       = 1
  config_json  = jsonencode({
    title  = var.dashboard_title
    panels = var.panels
  })
}

resource "local_file" "dashboard_name" {
  content     = var.dashboard_title
  filename    = "dashboard_name.txt"
}

output "dashboard_name" {
  value = local_file.dashboard_name.content
}