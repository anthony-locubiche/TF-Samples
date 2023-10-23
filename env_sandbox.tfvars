location           = "westeurope"
environment        = "tfsandbox"
azure_admin_groups = []
platform = {
  storage_account = {
    shared = {
      name                      = "shared00"
      sku_tier                  = "Standard"
      replication_type          = "LRS"
      is_datalake               = "true"
      access_tier               = "Hot"
      account_kind              = "StorageV2"
      min_tls_version           = "TLS1_2"
      account_tier              = "Standard"
      is_hns_enabled            = "true"
      enable_https_traffic_only = "true"
      container = {
        azfun = {
          name        = "azfun"
          access_type = "private"
          permission_spn = {
            #spn1 = {
            #role = "Storage Blob Data Contributor"
            #SPN  = ["mfgpilot04-mda-stsl-adls"]
            #}
          }
        },
        cost-followup = {
          name        = "cost-followup"
          access_type = "private"
          permission_group = {
            #group1 = {
            #role  = "Storage Blob Data Contributor"
            #GROUP = ["DIT_MDA_FinOps"]
            #},
            #group2 = {
            #role  = "Owner"
            #GROUP = ["DIT_MDA_Architects"]
            #}
          }
        }
      }
    }
  }
  keyvault = {
    sku                      = "standard"
    purge_protection_enabled = "false"
    #soft_delete_retention_days = "7"
    access_policy_spn = {
      #mfgpilot04-mda-stsl-adls = {
      #  SPN                     = "mfgpilot04-mda-stsl-adls"
      #  key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
      #  secret_permissions      = ["get", "set", "list", "delete", "purge", "recover"]
      #  certificate_permissions = []
      #}
    }
    access_policy_group = {
      #DIT_MDA_Subco_DevOps_Admin_NonProd = {
      #  group                   = "DIT_MDA_Subco_DevOps_Admin_NonProd"
      #  key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
      #  secret_permissions      = ["get", "set", "list", "delete", "purge", "recover"]
      #  certificate_permissions = []
      #}
    }
  }
  sql_server = {
    server_version      = "12.0"
    administrator_login = "sqladmin_platform"
    azuread_admin_group = ""
    authorized_networks = ["vnet-storage_default"]
    sql_db = {
      sharedDB = {
        collation   = "SQL_LATIN1_GENERAL_CP1_CI_AS"
        max_size_gb = 10
        sku_name = "GP_Gen5_2"
        min_capacity                = "0.5"
        auto_pause_delay_in_minutes = 60
        create_mode = "Default"
      }
    }
  }
}

applications = {
  app1 = {
    storage_account = {
      hot = {
        name                      = "datalake00"
        sku_tier                  = "Standard"
        replication_type          = "LRS"
        is_datalake               = "true"
        access_tier               = "Hot"
        account_kind              = "StorageV2"
        min_tls_version           = "TLS1_2"
        account_tier              = "Standard"
        is_hns_enabled            = "true"
        enable_https_traffic_only = "true"
        container = {
          referentials = {
            name        = "referentials"
            access_type = "private"
            permission_spn = {
              #spn1 = {
              #  role = "Storage Blob Data Contributor"
              #  SPN  = ["mfgpilot04-mda-stsl-adls"]
              #}
            }
          },
          stats = {
            name        = "stats"
            access_type = "private"
            permission_spn = {
              #spn1 = {
              #role = "Storage Blob Data Contributor"
              #SPN  = ["mfgpilot04-mda-stsl-adls"]
              #}
            }
          }
        }
      },
      archive = {
        name                      = "archives00"
        sku_tier                  = "Standard"
        replication_type          = "LRS"
        is_datalake               = "false"
        access_tier               = "Hot"
        account_kind              = "StorageV2"
        min_tls_version           = "TLS1_2"
        account_tier              = "Standard"
        is_hns_enabled            = "false"
        enable_https_traffic_only = "true"
        container = {
          archives = {
            name        = "archives"
            access_type = "private"
            permission_spn = {
              #spn1 = {
              #  role = "Storage Blob Data Contributor"
              #  SPN  = ["mfgpilot04-mda-stsl-adls"]
              #}
            }
          }
        }
      }
    }
    keyvault = {
      sku                      = "standard"
      purge_protection_enabled = "false"
      #soft_delete_retention_days = "7"
      access_policy_spn = {
        #mfgpilot04-mda-stsl-adls = {
        #SPN                     = "mfgpilot04-mda-stsl-adls"
        #key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
        #secret_permissions      = ["get", "set", "list", "delete", "purge", "recover"]
        #certificate_permissions = []
        #}
        #databricks = {
        #SPN                     = "AzureDatabricks"
        #key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
        #secret_permissions      = ["get", "set", "list", "delete", "purge", "recover"]
        #certificate_permissions = []
        #}
      }
      access_policy_group = {
        #DIT_MDA_Subco_DevOps_Admin_NonProd = {
        #group                   = "DIT_MDA_Subco_DevOps_Admin_NonProd"
        #key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
        #secret_permissions      = ["get", "set", "list", "delete", "purge", "recover"]
        #certificate_permissions = []
        #}
      }

    }
  }
}