terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.41.0"
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
  default     = "MY DASHBOARD"
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
  default     = []
}

locals {
  dashboard_uid = replace(replace(lower(var.dashboard_title), " ", "-"), "[^a-z0-9-]", "")
}

resource "grafana_dashboard" "dynamic" {
  config_json = jsonencode({
    editable       = true
    title          = var.dashboard_title
    panels         = var.panels
    refresh        = "5s"
    schemaVersion  = 18
    version        = 0
  })
  folder = 0
}
