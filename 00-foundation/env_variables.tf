variable "location" {
  type = string
}
variable "environment" {
  type = string
}
variable "mda" {
  type = object({
    storage_account = map(object({
      name                      = string
      sku_tier                  = string
      replication_type          = string
      is_datalake               = string
      access_tier               = string
      account_kind              = string
      min_tls_version           = optional(string)
      account_tier              = string
      is_hns_enabled            = string
      enable_https_traffic_only = string
      container = map(object({
        name        = string
        access_type = string
        permission_spn = optional(map(object({
          role = string
          SPN  = list(string)
        })))
        permission_group = optional(map(object({
          role  = string
          GROUP = list(string)
        })))
      }))
    }))
    keyvault = object({
      sku                        = string
      purge_protection_enabled   = string
      soft_delete_retention_days = optional(string)
      access_policy_spn = map(object({
        SPN                     = string
        key_permissions         = list(any)
        secret_permissions      = list(any)
        certificate_permissions = list(any)
      }))
      access_policy_group = map(object({
        group                   = string
        key_permissions         = list(any)
        secret_permissions      = list(any)
        certificate_permissions = list(any)
      }))
    })
    sql_server = object({
      server_version      = string
      administrator_login = string
      azuread_admin_group = string
      sql_db = map(object({
        collation                        = string
        sku_name                         = string
        max_size_gb                      = number
        read_scale                       = optional(string)
        min_capacity                     = optional(string)
        auto_pause_delay_in_minutes      = number
        zone_redundant                   = optional(string)
        read_replica_count               = optional(string)
        create_mode                      = optional(string)
      }))
    })
  })
}

variable "projects" {
  type = map(
    object({
      storage_account = map(object({
        name                      = string
        sku_tier                  = string
        replication_type          = string
        is_datalake               = string
        access_tier               = string
        account_kind              = string
        min_tls_version           = string
        account_tier              = string
        is_hns_enabled            = string
        enable_https_traffic_only = string
        container = map(object({
          name        = string
          access_type = string
          permission_spn = optional(map(object({
            role = string
            SPN  = list(string)
          })))
          permission_group = optional(map(object({
            role  = string
            GROUP = list(string)
          })))
        }))
      }))
      keyvault = object({
        sku                        = string
        purge_protection_enabled   = string
        soft_delete_retention_days = optional(string)
        access_policy_spn = map(object({
          SPN                     = string
          key_permissions         = optional(list(any))
          secret_permissions      = optional(list(any))
          certificate_permissions = optional(list(any))
        }))
        access_policy_group = map(object({
          group                   = string
          key_permissions         = optional(list(any))
          secret_permissions      = optional(list(any))
          certificate_permissions = optional(list(any))
        }))
      })
      sql_server = optional(object({
        server_version      = string
        administrator_login = string
        azuread_admin_group = string
        sql_db = map(object({
          edition                          = string
          collation                        = string
          max_size_gb                   = string
          requested_service_objective_name = string
        }))
      }))
    })
  )
}

variable "tenant_id" {
  type        = string
  description = "tenant ID"
  default     = null
}

variable "azure_admin_groups" {
  type        = list
  description = "Admin group that add specific permission"

}