run "deploy" {
  command = apply
}

run "validate" {
  command = apply

  module {
    source = "../../modules/test-endpoint"
  }

  variables {
    endpoint = run.deploy.api_endpoint
  }

  assert {
    condition     = data.http.test_endpoint.status_code == 200
    error_message = "Unexpected status code: ${data.http.test_endpoint.status_code}"
  }

  assert {
    condition     = jsondecode(data.http.test_endpoint.response_body).message == "Hello, World!"
    error_message = "Unexpected response body: ${data.http.test_endpoint.response_body}"
  }
}

run "validate_404" {
  command = apply

  module {
    source = "../../modules/test-endpoint"
  }

  variables {
    endpoint = "${trimsuffix(run.deploy.api_endpoint, "/")}/does-not-exist"
  }

  assert {
    condition     = data.http.test_endpoint.status_code == 404
    error_message = "Expected 404, got ${data.http.test_endpoint.status_code}"
  }

  # Optionnel mais propre (API Gateway renvoie souvent {"message":"Not Found"})
  assert {
    condition     = jsondecode(data.http.test_endpoint.response_body).message == "Not Found"
    error_message = "Unexpected 404 body: ${data.http.test_endpoint.response_body}"
  }
}
