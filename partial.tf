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
  auth = "eyJrIjoiVkNWQ2RXTXdRdnR6dU1WSUxid1pYYm5SYzFOcTBpengiLCJuIjoiZ3JhZmFuYSIsImlkIjoxfQ=="
  # Grafana URL
  url  = "https://g-ebbc3b012b.grafana-workspace.us-east-1.amazonaws.com/?orgId=1"
}

variable "dashboard_title" {
  description = "Title of the dashboard"
  type        = string
  default     = "My Dashboard"
}

locals {
  # Generate the UID for the dashboard
  dashboard_uid = replace(replace(lower(var.dashboard_title), " ", "-"), "[^a-z0-9-]", "")
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
        }
        tooltip = {
          mode = "single"
          sort = "ascending"
        }
      }
      targets    = [
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
    }
  ]
}

resource "grafana_dashboard" "example" {
  config_json  = jsonencode({
    title  = var.dashboard_title
    panels = var.panels
  })
}


