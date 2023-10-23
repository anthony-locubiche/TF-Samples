variable "infra_prefix" {
  type = object({
    general = object({
      resource_group    = string
      policy_definition = string
      app_name          = string
    })
    networking = object({
      virtual_network         = string
      virtual_network_gateway = string
      gateway_connection      = string
      subnet                  = string
      route_table             = string
      network_security_group  = string
      peering                 = string
      application_gateway     = string
      private_end_point       = string
      service_connection      = string
    })
    compute_and_web = object({
      virtual_machines          = string
      virtual_machine_scale_set = string
      vm_storage_account        = string
      public_ip                 = string
      load_balancer             = string
      nic                       = string
      service_bus               = string
      service_bus_queues        = string
      app_services              = string
      app_configuration         = string
      apim                      = string
      function_apps             = string
      cloud_services            = string
    })
    databases = object({
      azure_sql_server            = string
      azure_sql_database          = string
      azure_cosmos_db_            = string
      azure_cache_for_redis       = string
      azure_database_for_mysql    = string
      sql_data_warehouse          = string
      sql_server_stretch_database = string
    })
    storage = object({
      storage_account    = string
      storsimple         = string
      hpc_cache          = string
      azure_netapp_files = string
    })
    ai_and_machine_learning = object({
      azure_search                     = string
      cognitive_services               = string
      azure_machine_learning_workspace = string
    })
    analytics_and_iot = object({
      azure_data_lake_storage    = string
      azure_data_lake_analytics  = string
      hdinsight_-_spark          = string
      hdinsight_-_hadoop         = string
      hdinsight_-_r_server       = string
      hdinsight_-_hbase          = string
      power_bi_embedded          = string
      stream_analytics           = string
      data_factory               = string
      event_hub                  = string
      event_hub_cluster          = string
      event_hub_namespace        = string
      azure_iot_hub              = string
      notification_hubs          = string
      notification_hub_namespace = string
      databricks                 = string
    })
    integration = object({
      logic_apps         = string
      service_bus        = string
      service_bus_queue_ = string
      service_bus_topic  = string
    })
    management_and_governance = object({
      blueprint               = string
      blueprint_assignment    = string
      azure_key_vault         = string
      log_analytics_workspace = string
      application_insights    = string
      recovery_services_vault = string
    })
  })
  default = {
    general = {
      resource_group    = "rg-"
      policy_definition = "policy-"
      app_name          = "mda"
    }
    networking = {
      virtual_network         = "vnet-"
      virtual_network_gateway = "vnet-gw-"
      gateway_connection      = "cn-"
      subnet                  = "subnet"
      route_table             = "rt-"
      network_security_group  = "nsg-"
      peering                 = "peering-"
      application_gateway     = "appgw-"
      private_end_point       = "privateendpoint-"
      service_connection      = "privateserviceconnection-"
    }
    compute_and_web = {
      virtual_machines          = "vm-"
      virtual_machine_scale_set = "vmss-"
      vm_storage_account        = "stvm"
      public_ip                 = "pip-"
      load_balancer             = "lb-"
      nic                       = "nic-"
      service_bus               = "sb-"
      service_bus_queues        = "sbq-"
      apim                      = "api-"
      app_configuration         = "ac-"
      app_services              = "appserviceplan-"
      function_apps             = "azfun-"
      cloud_services            = "azcs-"
    }
    databases = {
      azure_sql_server            = "sqlserver-"
      azure_sql_database          = "sqldb_"
      azure_cosmos_db_            = "cosdb-"
      azure_cache_for_redis       = "redis-"
      azure_database_for_mysql    = "mysql-"
      sql_data_warehouse          = "sqldw-"
      sql_server_stretch_database = "sqlstrdb-"
    }
    storage = {
      storage_account    = "sa"
      storsimple         = "ssimp"
      hpc_cache          = "hpcc"
      azure_netapp_files = "anf-"
    }
    ai_and_machine_learning = {
      azure_search                     = "srch-"
      cognitive_services               = "cs-"
      azure_machine_learning_workspace = "aml-"
    }
    analytics_and_iot = {
      azure_data_lake_storage    = "dls"
      azure_data_lake_analytics  = "dla"
      hdinsight_-_spark          = "hdis-"
      hdinsight_-_hadoop         = "hdihd-"
      hdinsight_-_r_server       = "hdir-"
      hdinsight_-_hbase          = "hdihb-"
      power_bi_embedded          = "pbiemb"
      stream_analytics           = "asa-"
      data_factory               = "df-"
      event_hub                  = "evh-"
      event_hub_cluster          = "evhc-"
      event_hub_namespace        = "evhcns-"
      azure_iot_hub              = "aih-"
      notification_hubs          = "anh-"
      notification_hub_namespace = "anhns-"
      databricks                 = "dbricks-"
    }
    integration = {
      logic_apps         = "logic-"
      service_bus        = "sb-"
      service_bus_queue_ = "sbq-"
      service_bus_topic  = "sbt-"
    }
    management_and_governance = {
      blueprint               = "bp-"
      blueprint_assignment    = "bpa-"
      azure_key_vault         = "kv-"
      log_analytics_workspace = "log-"
      application_insights    = "appi-"
      recovery_services_vault = "rsv-"
    }
  }
}

variable "tags" {
  type = object({
    common = object({
      Cost-Center      = string
      Criticality      = string
      Env-Type         = string
      Owner-Org        = string
      Owner-SubOrg     = string
      Owner            = string
      Security-Rating  = string
      Ops-Org          = string
      Ops-Org-Owner    = string
      Resource-Manager = string
    })
  })
  default = {
    common = {
      Cost-Center      = "CC"
      Criticality      = "Tier 3"
      Env-Type         = "Sandbox"
      Owner-Org        = "DIT"
      Owner-SubOrg     = "XXX"
      Owner            = "anthony.locubiche@avanade.com"
      Security-Rating  = "H"
      Ops-Org          = "DIT MDA"
      Ops-Org-Owner    = "DIT MDA"
      Resource-Manager = "Terraform"
    }
  }
}

variable "infra_dns" {
  type = object({
    Azure_Automation               = string
    Azure_SQL_Database             = string
    Azure_Synapse_Analytics        = string
    Storage_account_Blob           = string
    Storage_account_Table          = string
    Storage_account_Queue          = string
    Storage_account_File           = string
    Storage_account_Web            = string
    Storage_account_DFS            = string
    Azure_Cosmos_DB_SQL            = string
    Azure_Cosmos_DB_MongoDB        = string
    Azure_Cosmos_DB_Cassandra      = string
    Azure_Cosmos_DB_Gremlin        = string
    Azure_Cosmos_DB_Table          = string
    Azure_Database_for_PostgreSQL  = string
    Azure_Database_for_MySQL       = string
    Azure_Database_for_MariaDB     = string
    Azure_Key_Vault                = string
    Azure_Kubernetes_Service       = string
    Azure_Search                   = string
    Azure_Container_Registry       = string
    Azure_App_Configuration        = string
    Azure_Backup                   = string
    Azure_Site_Recovery            = string
    Azure_Event_Hubs               = string
    Azure_Service_Bus              = string
    Azure_IoT_Hub                  = string
    Azure_Relay                    = string
    Azure_Event_Grid               = string
    Azure_Web_Apps                 = string
    Azure_Machine_Learning_2       = string
    SignalR                        = string
    Azure_Monitor_1                = string
    Azure_Monitor_2                = string
    Azure_Monitor_3                = string
    Azure_Monitor_4                = string
    Cognitive_Services             = string
    Azure_File_Sync                = string
    Azure_Data_Factory_dataFactory = string
    Azure_Data_Factory_portal      = string
    Azure_Cache_for_Redis          = string
  })
  default = {
    Azure_Automation               = "privatelink.azure-automation.net"
    Azure_SQL_Database             = "privatelink.database.windows.net"
    Azure_Synapse_Analytics        = "privatelink.database.windows.net"
    Storage_account_Blob           = "privatelink.blob.core.windows.net"
    Storage_account_Table          = "privatelink.table.core.windows.net"
    Storage_account_Queue          = "privatelink.queue.core.windows.net"
    Storage_account_File           = "privatelink.file.core.windows.net"
    Storage_account_Web            = "privatelink.web.core.windows.net"
    Storage_account_DFS            = "privatelink.dfs.core.windows.net"
    Azure_Cosmos_DB_SQL            = "privatelink.documents.azure.com"
    Azure_Cosmos_DB_MongoDB        = "privatelink.mongo.cosmos.azure.com"
    Azure_Cosmos_DB_Cassandra      = "privatelink.cassandra.cosmos.azure.com"
    Azure_Cosmos_DB_Gremlin        = "privatelink.gremlin.cosmos.azure.com"
    Azure_Cosmos_DB_Table          = "privatelink.table.cosmos.azure.com"
    Azure_Database_for_PostgreSQL  = "privatelink.postgres.database.azure.com"
    Azure_Database_for_MySQL       = "privatelink.mysql.database.azure.com"
    Azure_Database_for_MariaDB     = "privatelink.mariadb.database.azure.com"
    Azure_Key_Vault                = "privatelink.vaultcore.azure.net"
    Azure_Kubernetes_Service       = "privatelink.{region}.azmk8s.io"
    Azure_Search                   = "privatelink.search.windows.net"
    Azure_Container_Registry       = "privatelink.azurecr.io"
    Azure_App_Configuration        = "privatelink.azconfig.io"
    Azure_Backup                   = "privatelink.{region}.backup.windowsazure.com"
    Azure_Site_Recovery            = "{region}.privatelink.siterecovery.windowsazure.com"
    Azure_Event_Hubs               = "privatelink.servicebus.windows.net"
    Azure_Service_Bus              = "privatelink.servicebus.windows.net"
    Azure_IoT_Hub                  = "privatelink.azure-devices.net"
    Azure_Relay                    = "privatelink.servicebus.windows.net"
    Azure_Event_Grid               = "privatelink.eventgrid.azure.net"
    Azure_Web_Apps                 = "privatelink.azurewebsites.net"
    Azure_Machine_Learning_1       = "privatelink.api.azureml.ms"
    Azure_Machine_Learning_2       = "privatelink.notebooks.azure.net"
    SignalR                        = "privatelink.service.signalr.net"
    Azure_Monitor_1                = "privatelink.monitor.azure.com"
    Azure_Monitor_2                = "privatelink.oms.opinsights.azure.com"
    Azure_Monitor_3                = "privatelink.ods.opinsights.azure.com"
    Azure_Monitor_4                = "privatelink.agentsvc.azure-automation.net"
    Cognitive_Services             = "privatelink.cognitiveservices.azure.com"
    Azure_File_Sync                = "privatelink.afs.azure.net"
    Azure_Data_Factory_dataFactory = "privatelink.datafactory.azure.net"
    Azure_Data_Factory_portal      = "privatelink.adf.azure.com"
    Azure_Cache_for_Redis          = "privatelink.redis.cache.windows.net"
  }
}

variable "location" {
  type = string
}
variable "environment" {
  type = string
}
variable "platform" {
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
  })
}

variable "applications" {
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

variable "log_analytics_config" {
  type = object({
      sku = string
      retention_in_days = number
  })
  default = {
    sku = "PerGB2018"
    retention_in_days = 30
  }
}