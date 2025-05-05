resource "azurerm_container_app_environment" "this" {
  name                           = var.environment.name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  infrastructure_subnet_id       = var.environment.subnet_id
  internal_load_balancer_enabled = var.environment.internal_load_balancer_enabled
  logs_destination               = var.environment.logs_destination
  log_analytics_workspace_id     = var.environment.log_analytics_workspace_id

  dynamic "workload_profile" {
    for_each = var.environment.workload_profile.name != "" ? [1] : []
    content {
      name                  = var.environment.workload_profile.name
      workload_profile_type = var.environment.workload_profile.type
      minimum_count         = var.environment.workload_profile.minimum_count
      maximum_count         = var.environment.workload_profile.maximum_count
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
  name                         = var.storage.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  account_name                 = var.storage.account_name
  share_name                   = var.storage.share_name
  access_key                   = var.storage.access_key
  access_mode                  = var.storage.access_mode
}

resource "azurerm_container_app" "gateway" {
  count                        = var.gateway.enabled ? 1 : 0
  depends_on                   = [azurerm_container_app.frontend, azurerm_container_app.backend]
  name                         = "${var.common_config.base_name}-${var.gateway.name_suffix}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.common_config.revision_mode
  workload_profile_name        = var.environment.workload_profile.name != "" ? var.environment.workload_profile.name : null

  template {
    min_replicas = var.common_config.min_replicas
    max_replicas = var.common_config.max_replicas

    container {
      name   = var.gateway.container_name
      image  = var.gateway.image
      cpu    = var.gateway.cpu
      memory = var.gateway.memory

      dynamic "env" {
        for_each = var.gateway.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  ingress {
    external_enabled           = var.gateway.ingress.external_enabled
    target_port                = var.gateway.ingress.target_port
    transport                  = var.common_config.ingress_transport
    allow_insecure_connections = var.common_config.allow_insecure_connections

    dynamic "traffic_weight" {
      for_each = var.common_config.traffic_weights
      content {
        latest_revision = traffic_weight.value.latest_revision
        revision_suffix = lookup(traffic_weight.value, "revision_suffix", null)
        percentage      = traffic_weight.value.percentage
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.common_config.user_assigned_identity_ids
  }

  registry {
    server   = var.common_config.registry.server
    identity = var.common_config.registry.identity_id
  }

  tags = var.tags
}

resource "azurerm_container_app" "frontend" {
  count                        = var.frontend.enabled ? 1 : 0
  depends_on                   = [azurerm_container_app.backend]
  name                         = "${var.common_config.base_name}-${var.frontend.name_suffix}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.common_config.revision_mode
  workload_profile_name        = var.environment.workload_profile.name != "" ? var.environment.workload_profile.name : null

  template {
    min_replicas = var.common_config.min_replicas
    max_replicas = var.common_config.max_replicas

    container {
      name   = var.frontend.container_name
      image  = var.frontend.image
      cpu    = var.frontend.cpu
      memory = var.frontend.memory

      dynamic "env" {
        for_each = var.frontend.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  ingress {
    external_enabled           = var.frontend.ingress.external_enabled
    target_port                = var.frontend.ingress.target_port
    transport                  = var.common_config.ingress_transport
    allow_insecure_connections = var.common_config.allow_insecure_connections

    dynamic "traffic_weight" {
      for_each = var.common_config.traffic_weights
      content {
        latest_revision = traffic_weight.value.latest_revision
        revision_suffix = lookup(traffic_weight.value, "revision_suffix", null)
        percentage      = traffic_weight.value.percentage
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.common_config.user_assigned_identity_ids
  }

  registry {
    server   = var.common_config.registry.server
    identity = var.common_config.registry.identity_id
  }

  tags = var.tags
}

resource "azurerm_container_app" "backend" {
  count                        = var.backend.enabled ? 1 : 0
  name                         = "${var.common_config.base_name}-${var.backend.name_suffix}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.common_config.revision_mode
  workload_profile_name        = var.environment.workload_profile.name != "" ? var.environment.workload_profile.name : null

  template {
    min_replicas = var.common_config.min_replicas
    max_replicas = var.common_config.max_replicas

    container {
      name   = var.backend.container_name
      image  = var.backend.image
      cpu    = var.backend.cpu
      memory = var.backend.memory

      dynamic "env" {
        for_each = var.backend.omrs_configs
        content {
          name        = env.key
          secret_name = lower(replace(env.key, "_", "-"))
        }
      }

      dynamic "volume_mounts" {
        for_each = var.backend.volume.enabled ? [1] : []
        content {
          name = var.backend.volume.name
          path = var.backend.volume.path
        }
      }
    }

    dynamic "volume" {
      for_each = var.backend.volume.enabled ? [1] : []
      content {
        name         = var.backend.volume.name
        storage_type = var.backend.volume.storage_type
        storage_name = azurerm_container_app_environment_storage.this.name
      }
    }
  }

  ingress {
    external_enabled           = var.backend.ingress.external_enabled
    target_port                = var.backend.ingress.target_port
    transport                  = var.common_config.ingress_transport
    allow_insecure_connections = var.common_config.allow_insecure_connections

    dynamic "traffic_weight" {
      for_each = var.common_config.traffic_weights
      content {
        latest_revision = traffic_weight.value.latest_revision
        revision_suffix = lookup(traffic_weight.value, "revision_suffix", null)
        percentage      = traffic_weight.value.percentage
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.common_config.user_assigned_identity_ids
  }

  registry {
    server   = var.common_config.registry.server
    identity = var.common_config.registry.identity_id
  }

  dynamic "secret" {
    for_each = { for k, v in var.backend.omrs_configs : lower(replace(k, "_", "-")) => v }
    content {
      name  = secret.key
      value = secret.value
    }
  }

  tags = var.tags
}