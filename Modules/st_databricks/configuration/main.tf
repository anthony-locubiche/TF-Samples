terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.73.0"
    }
    databricks = {
      source = "databrickslabs/databricks"
      version = ">= 0.3.6"
    }
  }
}

#provider "databricks" {
#  azure_workspace_resource_id = var.databricks_workspace_id
#}

######################################################################## Databricks Secret Scope ######################################################################
resource "databricks_secret_scope" "databricks_kv_secret_scope" {
  count = var.kv_id != "" ?  1 : 0
  name = var.kv_secret_scope
  keyvault_metadata {
    resource_id = var.kv_id
    dns_name = var.kv_uri
  }
  depends_on = [var.module_depends_on]
}
######################################################################## Databricks instance pool #####################################################################
resource "databricks_instance_pool" "instance_pool" {
  for_each = var.databricks_instance_pool != {} ? var.databricks_instance_pool : {}
  instance_pool_name                    = each.value["databricks_instance_pool_name"]
  min_idle_instances                    = each.value["databricks_instance_pool_min_idle_instances"]
  max_capacity                          = each.value["databricks_instance_pool_max_capacity"]
  idle_instance_autotermination_minutes = each.value["databricks_instance_pool_autotermination_minutes"]
  node_type_id                          = each.value["databricks_instance_pool_node_type_id"]
  custom_tags                           = each.value["databricks_instance_pool_custom_tags"]
  enable_elastic_disk                   = each.value["databricks_instance_pool_enable_elastic_disk"]
  preloaded_spark_versions              = each.value["databricks_instance_pool_preloaded_spark_versions"]

  dynamic "disk_spec" {
    for_each = each.value["databricks_instance_pool_disk_spec"]
    content{
      disk_type {
        ebs_volume_type = disk_spec.value.ebs_volume_type
      }
      disk_size  = disk_spec.value.disk_size
      disk_count = disk_spec.value.disk_count
    }
  }
  azure_attributes {
    availability       = "ON_DEMAND_AZURE"
    spot_bid_max_price = 0
  }
  depends_on = [var.module_depends_on]
}
######################################################################## Databricks Cluster ###########################################################################
# Cluster
resource "databricks_cluster" "cluster" {
  for_each = var.dbricks_cluster != {} ? var.dbricks_cluster : {}
  spark_version                = each.value["dbricks_cluster_spark_version"] != "" ? each.value["dbricks_cluster_spark_version"] : null
  node_type_id                 = each.value["dbricks_cluster_node_type_id"] != "" ? each.value["dbricks_cluster_node_type_id"] : null
  cluster_name                 = each.value["dbricks_cluster_name"] != "" ? each.value["dbricks_cluster_name"] : null
  driver_node_type_id          = each.value["dbricks_cluster_driver_node_type_id"] != "" ? each.value["dbricks_cluster_driver_node_type_id"] : null
  instance_pool_id             = each.value["dbricks_cluster_instance_pool_id"] != false && var.databricks_instance_pool != {}  ? databricks_instance_pool.instance_pool[element(keys(databricks_instance_pool.instance_pool),0)].id  : null
  policy_id                    = each.value["dbricks_cluster_policy_id"] != "" ? each.value["dbricks_cluster_policy_id"] : null
  autotermination_minutes      = each.value["dbricks_cluster_autotermination_minutes"] != null ? each.value["dbricks_cluster_autotermination_minutes"] : null
  enable_local_disk_encryption = each.value["dbricks_cluster_enable_local_disk_encryption"] != null ? each.value["dbricks_cluster_enable_local_disk_encryption"] : false
  custom_tags                  = each.value["dbricks_cluster_custom_tags"] != null ? each.value["dbricks_cluster_custom_tags"] : null
  spark_conf                   = each.value["dbricks_cluster_spark_conf"] != null ? each.value["dbricks_cluster_spark_conf"] : null
  is_pinned                    = each.value["dbricks_cluster_is_pinned"] != null ? each.value["dbricks_cluster_is_pinned"] : true
  spark_env_vars               = each.value["dbricks_cluster_spark_env_vars"] != null ? each.value["dbricks_cluster_spark_env_vars"] : null

  autoscale {
    min_workers = each.value["dbricks_cluster_min_workers"] != null ? each.value["dbricks_cluster_min_workers"] : 0
    max_workers = each.value["dbricks_cluster_max_workers"] != null ? each.value["dbricks_cluster_max_workers"] : 1
  }

  dynamic "library" {
    for_each = each.value["dbricks_cluster_libraries_python"]
    content{
      pypi {
        package     = library.value
      }
    }
  }
  dynamic "library" {
    for_each = each.value["dbricks_cluster_libraries_maven"]
    content{
      maven {
        coordinates = library.value
      }
    }
  }
  dynamic "init_scripts" {
    for_each = each.value["dbricks_cluster_dbfs_init_scripts"]
    content {
      dbfs {
        destination = init_scripts.value
      }
    }
  }
  dynamic "init_scripts" {
    for_each = each.value["dbricks_cluster_s3_init_scripts"]
    content {
      s3 {
        destination = init_scripts.value.destination
        region = init_scripts.value.region
      }
    }
  }
  dynamic "init_scripts" {
    for_each = each.value["dbricks_cluster_file_init_scripts"]
    content {
      file {
        destination = init_scripts.value
      }
    }
  }
  dynamic "cluster_log_conf" {
    for_each = each.value["dbricks_cluster_log_conf"]
    content {
      dbfs {
        destination = cluster_log_conf.value
      }
    }
  }
  depends_on = [var.module_depends_on]
}

# Cluster policy
resource "databricks_cluster_policy" "cluster_policy" {
  for_each     = var.dbricks_cluster_policy != {} && var.dbricks_cluster != {} ? var.dbricks_cluster_policy : {}
  name       = each.value["policy_name"]
  definition = var.policy != {} ? jsonencode(element(var.policy,each.value["policy_position"])) : "{}"
  depends_on = [
    var.module_depends_on
  ]
}

######################################################################## Databricks adls gen2 mount ###################################################################
resource "databricks_azure_adls_gen2_mount" "data_mount" {
  for_each = var.dbricks_adls_gen2_mount != {} ? var.dbricks_adls_gen2_mount : {}
  #provider = databricks
  client_id              = data.azurerm_key_vault_secret.kv_secret_app_id_for_storage_account[each.key].value
  tenant_id              = var.tenant_id
  mount_name             = each.value["dbricks_mount_name"] != "" ? each.value["dbricks_mount_name"] : ""
  container_name         = each.value["dbricks_container_name"] != "" ? each.value["dbricks_container_name"] : ""
  storage_account_name   = each.value["dbricks_storage_account_name"] != "" ? each.value["dbricks_storage_account_name"] : ""
  initialize_file_system = each.value["dbricks_initialize_file_system"] != null ? each.value["dbricks_initialize_file_system"] : false
  directory              = each.value["dbricks_directory"] != "" ? each.value["dbricks_directory"] : ""
  client_secret_key      = each.value["dbricks_client_secret_key"] #var.dbricks_client_secret_key
  client_secret_scope    = each.value["dbricks_kv_secret_scope"] != "" ? each.value["dbricks_kv_secret_scope"] : (var.kv_id != "" ? databricks_secret_scope.databricks_kv_secret_scope[0].name : "" )


  depends_on = [
    var.module_depends_on
  ]
}


######################################################################## Databricks folder creation ###################################################################
#resource "databricks_notebook" "databricks_notebook_folder" {
#  count    = length(var.dbricks_folder_path) > 0 ? length(var.dbricks_folder_path) : 0
#  source   = "${path.module}/resources/placeholder.py"
#  path     = element(var.dbricks_folder_path,count.index)
#  depends_on = [var.module_depends_on]
#}

######################################################################## Databricks folder permission #################################################################
#resource "databricks_permissions" "dbricks_cluster_permission" {
#  for_each = var.dbricks_cluster_permission != {} && var.dbricks_cluster != {} ? var.dbricks_cluster_permission : {}
#  cluster_id           = each.value["dbricks_cluster_name"] != "" ? databricks_cluster.cluster[each.value["dbricks_cluster_name"]].id : ""
#
#  access_control {
#    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
#    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
#    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
#  }
#  depends_on = [
#    var.module_depends_on
#  ]
#}

resource "databricks_permissions" "dbricks_cluster_permission" {
  provider = databricks
  for_each = var.dbricks_cluster != {} ? var.dbricks_cluster : {}
    cluster_id = databricks_cluster.cluster[each.key].id
    #Create as many 'access_control' blocks as there are in dbricks_cluster_access_controls block
    dynamic "access_control" {
      for_each = each.value["dbricks_cluster_access_controls"]
      content {
        group_name       = access_control.value["group_name"]
        permission_level = access_control.value["permission_level"] #i.e: CAN_ATTACH_TO, CAN_RESTART or CAN_MANAGE
      }
    }

  depends_on = [
    var.module_depends_on
  ]
}

resource "databricks_permissions" "dbricks_cluster_policy_permission" {
  for_each = var.dbricks_cluster_policy_permission != {} && var.dbricks_cluster != {} ? var.dbricks_cluster_policy_permission : {}
  cluster_policy_id = each.value["dbricks_cluster_policy_id"] != "" ? databricks_cluster_policy.cluster_policy[each.value["dbricks_cluster_policy_id"]].id : ""

  access_control {
    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
  }
  depends_on = [
    databricks_cluster_policy.cluster_policy,
    var.module_depends_on
  ]
}

#resource "databricks_permissions" "dbricks_notebook_permission" {
#  for_each = var.dbricks_notebook_permission != {} ? var.dbricks_notebook_permission : {}
#  notebook_path     = each.value["dbricks_notebook_path"] != "" ? each.value["dbricks_notebook_path"] : ""
#
#  access_control {
#    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
#    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
#    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
#  }
#  depends_on = [
#    databricks_notebook.databricks_notebook_folder,
#    var.module_depends_on
#  ]
#}

#resource "databricks_permissions" "dbricks_directory_permission" {
#  for_each = var.dbricks_directory_permission != {} ? var.dbricks_directory_permission : {}
#  directory_path    = each.value["dbricks_directory_path"] != "" ? each.value["dbricks_directory_path"] : ""
#
#  access_control {
#    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
#    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
#    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
#  }
#  depends_on = [
#    databricks_notebook.databricks_notebook_folder,
#    var.module_depends_on
#  ]
#}

resource "databricks_permissions" "dbricks_authorization_permission" {
  for_each = var.dbricks_authorization_permission != {} ? var.dbricks_authorization_permission : {}
  authorization     = each.value["dbricks_authorization"] != "" ? each.value["dbricks_authorization"] : ""

  access_control {
    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
  }
  depends_on = [var.module_depends_on]
}

resource "databricks_permissions" "dbricks_instance_pool_permission" {
  for_each = var.dbricks_instance_pool_permission != {} && var.databricks_instance_pool != {} ? var.dbricks_instance_pool_permission : {}
  instance_pool_id  = each.value["dbricks_instance_pool_id"] != "" ? each.value["dbricks_instance_pool_id"] : ""

  access_control {
    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
  }
  depends_on = [var.module_depends_on]
}

resource "databricks_permissions" "dbricks_dbricks_job_permission" {
  for_each = var.dbricks_dbricks_job_permission != {} ? var.dbricks_dbricks_job_permission : {}
  job_id            = each.value["dbricks_job_id"] != "" ? each.value["dbricks_job_id"] : ""

  access_control {
    user_name        = each.value["dbricks_user_name"] != "" ? each.value["dbricks_user_name"] : ""
    group_name       = each.value["dbricks_group_name"] != "" ? each.value["dbricks_group_name"] : ""
    permission_level = each.value["dbricks_permission_level"] != "" ? each.value["dbricks_permission_level"] : ""
  }
  depends_on = [var.module_depends_on]
}
######################################################################## Databricks users #############################################################################
resource "databricks_user" "databricks_project_users" {
  for_each                   = var.dbricks_project_users != [] ? toset(var.dbricks_project_users) : []
  user_name                  = each.key
  display_name               = replace(replace(split("@", each.key)[0], "-ext", ""), "."," ")
  allow_cluster_create       = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create
  #TODO: Access to SQL Analytics must be done with databricks_sql_access property
  #allow_sql_analytics_access = var.allow_sql_analytics_access
#  lifecycle {
#    ignore_changes = [
#      allow_instance_pool_create,
#      allow_sql_analytics_access
#    ]
#  }
}
######################################################################## Databricks group #############################################################################
resource "databricks_group" "databricks_group" {
  for_each = var.dbricks_groupname != [] ? toset(var.dbricks_groupname) : []
  display_name = each.key
}
######################################################################## Databricks group member ######################################################################
resource "databricks_group_member" "databricks_group_member" {
  for_each       = var.databricks_group_member != {} ? var.databricks_group_member : {}
  group_id   = var.databricks_group_member != {} ? databricks_group.databricks_group[each.value["dbricks_group_name"]].id : null
  member_id  = var.databricks_group_member != {} ? databricks_user.databricks_project_users[each.value["dbricks_member_name"]].id : null
  depends_on = [databricks_group.databricks_group,databricks_user.databricks_project_users]
}

#Create databricks users
resource "databricks_user" "users" {
  for_each  = toset(distinct(concat(local.admin_users_object_id, local.users_object_id)))  #Concatenate all AAD groups to create all users
  user_name = data.azuread_user.all_users[each.value].mail
}

#Assign users to groups
resource "databricks_group_member" "i-am-adm-user" {
  for_each = toset(local.admin_users_object_id)
  group_id  = data.databricks_group.admins_group.id
  member_id = databricks_user.users[each.value].id
}
resource "databricks_group_member" "i-am-user" {
  for_each = toset(local.users_object_id)
  group_id  = data.databricks_group.users_group.id
  member_id = databricks_user.users[each.value].id
}

######################################################################## Databricks admin users #######################################################################
# THIS PART OF CODE IS COMMENTED BECAUSE AT THIS MOMENT WE CAN'T USE THE ADMIN USER RESOURCE
#data "databricks_group" "databricks_admins_group" {
#    count = var.dbricks_project_admin_users != [] ? 1 : 0
#    display_name = "admins"
#}
#
#resource "databricks_user" "databricks_project_admin_users" {
#  for_each                   = var.dbricks_project_admin_users != [] ? toset(var.dbricks_project_admin_users) : []
#  user_name                  = each.key
#  display_name               = replace(replace(split("@", each.key)[0], "-ext", ""), "."," ")
#}
#
#resource "databricks_group_member" "databricks_admin_member" {
#  for_each  = var.dbricks_project_admin_users != [] ? toset(var.dbricks_project_admin_users) : []
#  group_id  = data.databricks_group.databricks_admins_group[0].id
#  member_id = databricks_user.databricks_project_admin_users[each.key].id
#}

######################################################################## Databricks global init script ################################################################
resource "databricks_global_init_script" "databricks_artifactory_init_script" {
  #count = var.databricks_workspace_id != null ? 1 : 0
  content_base64 = base64encode(<<-EOT
    #!/bin/bash
    pip config set global.index-url ${var.artifactory_index_url}
    pip config set install.trusted-host ${var.artifactory_hostname}
    EOT
  )
  name           = var.artifactory_name
  enabled        = var.artifactory_enabled
  depends_on = [var.module_depends_on]
}
######################################################################## Application insights #########################################################################
resource "azurerm_application_insights" "dbricks_appinsights" {
  for_each            = var.dbricks_appinsights != {} ? var.dbricks_appinsights : {}
  name                = each.value["insights_name"]
  location            = var.location
  resource_group_name = var.dbricks_rg_name
  application_type    = each.value["insights_type"]
  retention_in_days   = each.value["retention_in_days"]
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.default_tags
}

resource "azurerm_key_vault_secret" "insights-connectionstring" {
  for_each     = var.dbricks_appinsights != {} ? var.dbricks_appinsights : {}
  name         = each.value["key_vault_secret_name"]
  value        = var.dbricks_appinsights != {} ? azurerm_application_insights.dbricks_appinsights[each.key].connection_string : null
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_application_insights.dbricks_appinsights]
}

