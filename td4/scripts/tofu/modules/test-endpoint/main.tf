terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

resource "time_sleep" "wait_for_api" {
  create_duration = "15s"
}

data "http" "test_endpoint" {
  url = var.endpoint

  depends_on = [time_sleep.wait_for_api]
}
