terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      #version = ">= 2.0.0"  # Specify the desired version here
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
}

variable "panels" {
  description = "Panel configurations for the dashboard"
}

locals {
  panels = var.panels
}

resource "grafana_dashboard" "example" {
  config_json = templatefile("${path.module}/panel_template.tpl", {
    dashboard_title = var.dashboard_title,
    panels          = local.panels
  })
}
