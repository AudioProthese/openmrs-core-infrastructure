resource "azurerm_container_app_environment" "this" {
  name                           = var.container_app_environment_name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  infrastructure_subnet_id       = var.aca_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  logs_destination               = var.logs_destination
  log_analytics_workspace_id     = var.log_analytics_workspace_id

  dynamic "workload_profile" {
    for_each = var.workload_profile_name != "" ? [1] : []
    content {
      name                  = var.workload_profile_name
      workload_profile_type = var.workload_profile_type
      minimum_count         = var.workload_profile_min_count
      maximum_count         = var.workload_profile_max_count
    }
  }

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name,
      workload_profile
    ]
  }

  tags = var.tags
}

resource "azurerm_container_app_environment_storage" "this" {
  name                         = var.environment_storage_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  account_name                 = var.storage_account_name
  share_name                   = var.openmrs_fileshare_name
  access_key                   = var.primary_access_key
  access_mode                  = var.environment_storage_access_mode
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.revision_mode
  workload_profile_name        = var.workload_profile_name != "" ? var.workload_profile_name : null

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    dynamic "container" {
      for_each = var.enable_gateway ? [1] : []
      content {
        name   = "gateway"
        image  = var.container_image_gateway
        cpu    = var.cpu_gateway
        memory = var.memory_gateway

        dynamic "env" {
          for_each = var.gateway_env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }

    dynamic "container" {
      for_each = var.enable_frontend ? [1] : []
      content {
        name   = "frontend"
        image  = var.container_image_frontend
        cpu    = var.cpu_frontend
        memory = var.memory_frontend

        dynamic "env" {
          for_each = var.frontend_env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }

    dynamic "container" {
      for_each = var.enable_backend ? [1] : []
      content {
        name   = "backend"
        image  = var.container_image_backend
        cpu    = var.cpu_backend
        memory = var.memory_backend

        dynamic "env" {
          for_each = var.omrs_configs
          content {
            name        = env.key
            secret_name = lower(replace(env.key, "_", "-"))
          }
        }

        dynamic "volume_mounts" {
          for_each = var.enable_backend_volume ? [1] : []
          content {
            name = "openmrs-data"
            path = var.backend_volume_path
          }
        }
      }
    }

    dynamic "volume" {
      for_each = var.enable_backend_volume ? [1] : []
      content {
        name         = "openmrs-data"
        storage_type = var.storage_type
        storage_name = azurerm_container_app_environment_storage.this.name
      }
    }
  }

  dynamic "ingress" {
    for_each = var.enable_ingress ? [1] : []
    content {
      external_enabled = var.ingress_external_enabled
      target_port      = var.target_port
      transport        = var.ingress_transport

      dynamic "traffic_weight" {
        for_each = var.traffic_weights
        content {
          latest_revision = traffic_weight.value.latest_revision
          revision_suffix = lookup(traffic_weight.value, "revision_suffix", null)
          percentage      = traffic_weight.value.percentage
        }
      }
    }
  }

  dynamic "identity" {
    for_each = length(var.user_assigned_identity_ids) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.user_assigned_identity_ids
    }
  }

  dynamic "registry" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      server   = var.registry_server
      identity = var.registry_identity_id != "" ? var.registry_identity_id : null
    }
  }

  dynamic "secret" {
    for_each = { for k, v in var.omrs_configs : lower(replace(k, "_", "-")) => v }
    content {
      name  = secret.key
      value = secret.value
    }
  }

  tags = var.tags
}