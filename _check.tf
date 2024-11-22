check "database_data_non_integrated_viewer" {
  assert {
    condition = (
      (local.database_data.non_integrated_viewer == "false" && length(local.database_data.metadata_database_type) == 0) ||
      (local.database_data.non_integrated_viewer == "true" && length(local.database_data.metadata_database_type) > 0 && length(local.database_data.metadata_database_schema) > 0)
    )
    error_message = "When non_integrated_viewer is false, no other database data should be provided. When non_integrated_viewer is true, metadata_database_type, metadata_database_schema, and secrets_manager_* variables should be provided."
  }
}
