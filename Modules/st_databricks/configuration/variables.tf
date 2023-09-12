######################################################### PROVIDER #############################################################
variable databricks_workspace_id {
  type    = string
  default = null
}
variable module_depends_on {
  type        = any
  default     = []
}
######################################################### DATABRICKS SECRET SCOPE ##############################################
variable kv_secret_scope {
  type    = string
  default = "kv-secret-scope"
}
variable kv_id {
  type    = string
  default = ""
}
variable kv_uri {
  type    = string
  default = ""
}
######################################################### INSTANCE POOL ########################################################
variable databricks_instance_pool {
  description = "Specifies the instance pool parameters"
  type = map(object({
    databricks_instance_pool_name                     = string,
    databricks_instance_pool_min_idle_instances       = number,
    databricks_instance_pool_max_capacity             = number,
    databricks_instance_pool_node_type_id             = string,
    databricks_instance_pool_autotermination_minutes  = number,
    databricks_instance_pool_disk_spec                = list(object({ ebs_volume_type = string, disk_size = number, disk_count = number})),
    databricks_instance_pool_custom_tags              = map(string),
    databricks_instance_pool_enable_elastic_disk      = bool,
    databricks_instance_pool_preloaded_spark_versions = list(string)
  }))
  default = {}
}
######################################################### DATABRICKS CLUSTER ###################################################
# Cluster Creation
variable dbricks_cluster {
  description = "Specifies the list of cluster to create"
  type = map(object({
    dbricks_cluster_name                 = string,
    dbricks_cluster_spark_version                = string,
    dbricks_cluster_driver_node_type_id          = string,
    dbricks_cluster_node_type_id                 = string,
    dbricks_cluster_instance_pool_id             = bool,
    dbricks_cluster_policy_id                    = string,
    dbricks_cluster_autotermination_minutes      = number,
    dbricks_cluster_enable_local_disk_encryption = bool,
    dbricks_cluster_spark_conf                   = map(string),
    dbricks_cluster_spark_env_vars               = map(string),
    dbricks_cluster_custom_tags                  = map(string),
    dbricks_cluster_is_pinned                    = bool,
    #dbricks_cluster_num_workers                  = number,
    dbricks_cluster_min_workers                  = number,
    dbricks_cluster_max_workers                  = number,
    dbricks_cluster_libraries_python             = list(string),
    dbricks_cluster_libraries_maven              = list(string),
    dbricks_cluster_dbfs_init_scripts            = list(string),
    dbricks_cluster_s3_init_scripts              = list(object({ destination = string, region = string})),
    dbricks_cluster_file_init_scripts            = list(string),
    dbricks_cluster_log_conf                     = list(string),
    dbricks_cluster_access_controls              = map(object({
      group_name              = string
      permission_level        = string #i.e: CAN_ATTACH_TO, CAN_RESTART or CAN_MANAGE
    }))
  }))
  default = {}
}
#Cluster policy
variable dbricks_cluster_policy {
  description = "Specifies the list of cluster policy to create"
  type = map(object({
    policy_name = string,
    policy_position = number
  }))
  default = {}
}
variable policy {
  type    = any
  default = {}
}
######################################################### DATABRICKS ADLS GEN2 MOUNT ###########################################
variable dbricks_adls_gen2_mount {
  description = "Specifies the list of cluster to create"
  type = map(object({
    dbricks_container_name         = string,
    dbricks_storage_account_name   = string,
    dbricks_mount_name             = string,
    dbricks_initialize_file_system = bool,
    dbricks_directory              = string,
    dbricks_kv_secret_scope        = string,
    dbricks_client_secret_key = string,
    keyvault_name = string,
    keyvault_rg = string,
    kv_secret_app_id_name = string
  }))
  default = {}
}
#variable dbricks_client_secret_key {
#  type    = string
#  default = ""
#}
#variable dbricks_client_secret_scope {
#  type    = string
#  default = ""
#}
#variable client_id {
#  type    = string
#  default = ""
#}
variable tenant_id {
  type    = string
  default = ""
}
######################################################### DATABRICKS FOLDER CREATION ###########################################
variable dbricks_folder_path {
  type    = list
  default = []
}
######################################################### DATABRICKS PERMISSION CREATION #######################################
# Cluster permission
variable dbricks_cluster_permission {
  description = "Specifies set of permission to apply on a cluster"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_cluster_name      = string
  }))
  default = {}
}
variable dbricks_cluster_policy_permission {
  description = "Specifies set of permission to apply on a cluster policy"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_cluster_policy_id = string
  }))
  default = {}
}
variable dbricks_notebook_permission {
  description = "Specifies set of permission to apply on a notebook"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_notebook_path     = string
  }))
  default = {}
}
variable dbricks_directory_permission {
  description = "Specifies set of permission to apply on a folder"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_directory_path    = string
  }))
  default = {}
}
variable dbricks_authorization_permission {
  description = "Specifies set of permission to apply on a token"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_authorization     = string
  }))
  default = {}
}
variable dbricks_instance_pool_permission {
  description = "Specifies set of permission to apply on a instance pool"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_instance_pool_id  = string
  }))
  default = {}
}
variable dbricks_dbricks_job_permission {
  description = "Specifies set of permission to apply on a job"
  type = map(object({
    dbricks_user_name         = string,
    dbricks_group_name        = string,
    dbricks_permission_level  = string,
    dbricks_job_id            = string
  }))
  default = {}
}
######################################################### DATABRICKS USERS #####################################################
variable dbricks_project_users {
  type    = list(string)
  default     = []
}
variable allow_cluster_create {
  type        = bool
  default     = false
}
variable allow_instance_pool_create {
  type        = bool
  default     = false
}
variable allow_sql_analytics_access {
  type        = bool
  default     = false
}
######################################################### DATABRICKS GROUP #####################################################
variable dbricks_groupname {
  type    = list(string)
  default     = []
}
variable "databricks_admin_AAD_groups" {
  type = list
  description = "AD Groups to the Databricks Workspace that gives Admin role"
}
variable "databricks_user_AAD_groups" {
  type = list
  description = "Authorized AD Groups to the Databricks Workspace as simple users"
}
######################################################### DATABRICKS GROUP MEMBER ##############################################
variable databricks_group_member {
  description = "Specifies set of permission to apply on a instance pool"
  type = map(object({
    dbricks_group_name         = string,
    dbricks_member_name        = string
  }))
  default = {}
}
######################################################### DATABRICKS USERS ADMIN ###############################################
#variable dbricks_project_admin_users {
#  type    = list(string)
#  default     = []
#}
######################################################### DATABRICKS GLOBAL INIT SCRIPTS #######################################
variable artifactory_index_url {
  type        = string
  default     = "https://artifacts.st.com/artifactory/api/pypi/pypi-python-remote/simple"
}
variable artifactory_hostname {
  type        = string
  default     = "artifacts.st.com"
}
variable artifactory_name {
  type        = string
  default     = "artifactory"
}
variable artifactory_enabled {
  type        = bool
  default     = true
}
######################################################### DATABRICKS APPLICATION INSIGHT #######################################
variable dbricks_appinsights {
  description = "Specifies the list of application insight to create "
  type = map(object({
    insights_name         = string,
    insights_type         = string,
    retention_in_days     = number,
    key_vault_secret_name = string
  }))
  default                  = {
  }
}
variable location {
  type        = string
  default     = ""
}
variable dbricks_rg_name {
  type        = string
  default     = ""
}
variable log_analytics_workspace_id {
  type        = string
  default     = null
}
variable default_tags {
  description = "List of default tags to be created"
  type        = map
  default     = {}
}
variable key_vault_id {
  type        = string
  default     = null
}