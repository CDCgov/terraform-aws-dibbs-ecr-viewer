check "ensure_one_root_service" {
  assert {
    condition     = length([for service in local.service_data : service if service.root_service == true]) <= 1
    error_message = "Multiple services have root_service set to true, only one service can be marked as the root service"
  }
}