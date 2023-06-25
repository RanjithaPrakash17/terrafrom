terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.37.2"
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
  # Description for the variable
  description = "Title of the dashboard"
  # Type of the variable
  type        = string
}

locals {
  # Generate the UID for the dashboard
  dashboard_uid = replace(replace(lower(var.dashboard_title), " ", "-"), "[^a-z0-9-]", "")
}

resource "grafana_dashboard" "simple" {
  config_json = templatefile("${path.module}/dashboard_template.json", {
    # Generate the config JSON for the dashboard
    dashboard_title = var.dashboard_title
  })
}
