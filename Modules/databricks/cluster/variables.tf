# Databricks attributes
variable "cluster_name" {
  type    = string
  description = "Cluster name, which doesn’t have to be unique."
}
variable "spark_version" {
  type    = string
  description = "Runtime version of the cluster. Any supported databricks_spark_version id."
}
variable "node_type_id" {
  type    = string
  description = "Any supported databricks_node_type id. If instance_pool_id is specified, this field is not needed"
}
variable "driver_node_type_id" {
  type    = string
  description = "The node type of the Spark driver. If unset, API will set the driver node type to the same value as node_type_id defined above."
}
variable "instance_pool_id" {
  description = "Required if node_type_id is not given; To reduce cluster start time, you can attach a cluster to a predefined pool of idle instances. When attached to a pool, a cluster allocates its driver and worker nodes from the pool."
}
variable "num_workers" {
  type    = number
  description = "Define the fixed-size of the cluster (or use min_workers & max_workers instead). When using a Single Node cluster, num_workers needs to be 0"
}
variable "min_workers" {
  type    = number
  description = "The minimum number of workers to which the cluster can scale down when underutilized. It is also the initial number of workers the cluster will have after creation."
}
variable "max_workers" {
  type    = number     #Not required if SingleNode
  description = "The maximum number of workers to which the cluster can scale up when overloaded. max_workers must be strictly greater than min_workers."
}
variable "autotermination_minutes" {
  type    = number
  description = "Automatically terminate the cluster after being inactive for this time in minutes. If not set, Databricks won't automatically terminate an inactive cluster. If specified, the threshold must be between 10 and 10000 minutes. You can also set this value to 0 to explicitly disable automatic termination."
}
variable "custom_tags" {
  description = "Additional tags for cluster resources. Databricks will tag all cluster resources with these tags in addition to 'default_tags'."
}
variable "access_controls" {
  description = "Define which groups can RESTART, ATTACH_TO or MANAGE the cluster."
}
variable "init_scripts" {
  description = "You can specify up to 10 different init scripts for the specific cluster. If you want a shell script to run on all clusters and jobs within the same workspace, you should consider databricks_global_init_script."
}
variable "spark_conf" {
  description = "Map with key-value pairs to fine-tune Spark clusters, where you can provide custom Spark configuration properties in a cluster configuration"
}
#Key Vault secret attributes
#variable "keyvault_workspace_id" {
#  description = "ID of Key Vault used to store the cluster secret"
#}
#variable "keyvault_secret_name" {
#  type    = string
#  description = "Name of the secret related to the cluster"
#}