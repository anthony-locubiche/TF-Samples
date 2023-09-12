locals {
  _sql_databases_platform = flatten([
    for sql_db_key, sql_db in var.mda.sql_server.sql_db : {
      project_key                 = "mda"
      sql_db_key                  = sql_db_key
      db_name                     = lower("${var.infra_prefix.databases.azure_sql_database}${sql_db_key}_${var.environment}")
      collation                   = sql_db.collation
      sku_name                    = sql_db.sku_name
      max_size_gb                 = sql_db.max_size_gb
      read_scale                  = sql_db.read_scale
      min_capacity                = sql_db.min_capacity
      auto_pause_delay_in_minutes = sql_db.auto_pause_delay_in_minutes
      zone_redundant              = sql_db.zone_redundant
      read_replica_count          = sql_db.read_replica_count
    }
  ])

  sql_dbs_platform = {
    for obj in local._sql_databases_platform : "${obj.project_key}.${obj.sql_db_key}" => obj
  }
}

module "sql_databases_common" {
  source   = "../Modules/sql/database"
  for_each = local.sql_dbs_platform


  name                        = each.value.db_name
  sql_server_id               = module.sqlserver_platform.id
  collation                   = each.value.collation
  sku_name                    = each.value.sku_name
  max_size_gb                 = each.value.max_size_gb
  read_scale                  = each.value.read_scale
  min_capacity                = each.value.min_capacity
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  zone_redundant              = each.value.zone_redundant
  read_replica_count          = each.value.read_replica_count
  tags                        = merge({ "ST-App-Name" = format("MDA COMMON") }, var.tags.common)

  log_analytics_workspace_name = module.loganalytics.name #data.azurerm_log_analytics_workspace.log_analytics.name
  log_analytics_workspace_id   = module.loganalytics.id   #data.azurerm_log_analytics_workspace.log_analytics.id

  depends_on = [
    module.loganalytics,
    module.sqlserver_platform
  ]
}
