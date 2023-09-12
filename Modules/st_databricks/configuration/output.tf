############################################### databricks secret scope section ###############################################
/*output "secret_scope_id" {
   value = var.databricks_workspace_id != null && var.kv_id != "" ? databricks_secret_scope.databricks_kv_secret_scope[0].id : null
 }
output "backend_type" {
   value = var.databricks_workspace_id != null && var.kv_id != "" ? databricks_secret_scope.databricks_kv_secret_scope[0].backend_type : null
 }*/
############################################### databricks instance pool section ##############################################
output "instance_pool_id" {
  value = var.databricks_workspace_id != null && var.databricks_instance_pool != {} ? values(databricks_instance_pool.instance_pool)[*].id : null
}
############################################### databricks cluster scope section ##############################################
output "cluster_scope_id" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster != {} ? values(databricks_cluster.cluster)[*].id : null
}
output "default_tags" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster != {} ? values(databricks_cluster.cluster)[*].default_tags : null
}
output "state" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster != {} ? values(databricks_cluster.cluster)[*].state : null
}
############################################### databricks cluster policy section ##############################################
output "cluster_policy_id" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_policy != {} && var.dbricks_cluster != {} ? values(databricks_cluster_policy.cluster_policy)[*].id : null
}
output "cluster_policy_policy_id" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_policy != {} && var.dbricks_cluster != {} ? values(databricks_cluster_policy.cluster_policy)[*].policy_id : null
}
############################################### databricks adls gen2 mount section ############################################
output "adls_gen2_mount_id" {
  value = var.databricks_workspace_id != null && var.dbricks_adls_gen2_mount != {} && var.dbricks_cluster != {} ? values(databricks_azure_adls_gen2_mount.data_mount)[*].id : null
}
output "adls_gen2_mount_source" {
  value = var.databricks_workspace_id != null && var.dbricks_adls_gen2_mount != {} && var.dbricks_cluster != {} ? values(databricks_azure_adls_gen2_mount.data_mount)[*].source : null
}
############################################### databricks notebook section ####################################################
#output "notebook_id" {
#  value = var.databricks_workspace_id != null && length(var.dbricks_folder_path) > 0 ? databricks_notebook.databricks_notebook_folder[*].id : null
#}
#output "notebook_url" {
#  value = var.databricks_workspace_id != null && length(var.dbricks_folder_path) > 0 ? databricks_notebook.databricks_notebook_folder[*].url : null
#}
#output "notebook_object_id" {
#  value = var.databricks_workspace_id != null && length(var.dbricks_folder_path) > 0 ? databricks_notebook.databricks_notebook_folder[*].object_id : null
#}
############################################### databricks permission section ####################################################
output "cluster_permissions_id" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_permission != {} ? values(databricks_permissions.dbricks_cluster_permission)[*].id : null
}
output "cluster_permissions_object_type" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_permission != {} ? values(databricks_permissions.dbricks_cluster_permission)[*].object_type : null
}
output "cluster_policy_permissions_id" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_policy_permission != {} ? values(databricks_permissions.dbricks_cluster_policy_permission)[*].id : null
}
output "cluster_policy_permissions_object_type" {
  value = var.databricks_workspace_id != null && var.dbricks_cluster_policy_permission != {} ? values(databricks_permissions.dbricks_cluster_policy_permission)[*].object_type : null
}
#output "notebook_permissions_id" {
#  value = var.databricks_workspace_id != null && var.dbricks_notebook_permission != {} ? values(databricks_permissions.dbricks_notebook_permission)[*].id : null
#}
#output "notebook_permissions_object_type" {
#  value = var.databricks_workspace_id != null && var.dbricks_notebook_permission != {} ? values(databricks_permissions.dbricks_notebook_permission)[*].object_type : null
#}
#output "directory_permissions_id" {
#  value = var.databricks_workspace_id != null && var.dbricks_directory_permission != {} ? values(databricks_permissions.dbricks_directory_permission)[*].id : null
#}
#output "directory_permissions_object_type" {
#  value = var.databricks_workspace_id != null && var.dbricks_directory_permission != {} ? values(databricks_permissions.dbricks_directory_permission)[*].object_type : null
#}
output "directory_authorization_id" {
  value = var.databricks_workspace_id != null && var.dbricks_authorization_permission != {} ? values(databricks_permissions.dbricks_authorization_permission)[*].id : null
}
output "directory_authorization_object_type" {
  value = var.databricks_workspace_id != null && var.dbricks_authorization_permission != {} ? values(databricks_permissions.dbricks_authorization_permission)[*].object_type : null
}
output "directory_instance_pool_id" {
  value = var.databricks_workspace_id != null && var.dbricks_instance_pool_permission != {} ? values(databricks_permissions.dbricks_instance_pool_permission)[*].id : null
}
output "directory_instance_pool_object_type" {
  value = var.databricks_workspace_id != null && var.dbricks_instance_pool_permission != {} ? values(databricks_permissions.dbricks_instance_pool_permission)[*].object_type : null
}
output "directory_job_id" {
  value = var.databricks_workspace_id != null && var.dbricks_dbricks_job_permission != {} ? values(databricks_permissions.dbricks_dbricks_job_permission)[*].id : null
}
output "directory_job_object_type" {
  value = var.databricks_workspace_id != null && var.dbricks_dbricks_job_permission != {} ? values(databricks_permissions.dbricks_dbricks_job_permission)[*].object_type : null
}