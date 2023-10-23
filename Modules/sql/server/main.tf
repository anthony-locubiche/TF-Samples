resource "azurerm_mssql_server" "sql_server" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true #NEED TO BE IN TRUE FOR THE DEPLOYMENT, IF NOT DATABASES DEPLOYMENT WILL FAIL
  tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_virtual_network_rule" "network_rules" {
  for_each  = var.virtual_network_subnet_ids
  name      = "Rule for ${each.value} subnet"
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = each.value
}

# resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {

#   for_each = toset(var.virtual_network_subnet_ids)

#   name                = each.key
#   resource_group_name = var.resource_group_name
#   server_name         = azurerm_sql_server.sql_server.name
#   subnet_id           = each.value
# }


# ##APP SQLSERVERNAME NEED TO GET DIRECTORY READ RIGHT FOR THIS SCRIPT
# # PowerShell script for creating a new SQL user called myapp using application AppSP with secret
# # AppSP is part of an Azure AD admin for the Azure SQL server below

# #Download latest  MSAL  - https://www.powershellgallery.com/packages/MSAL.PS
# Import-Module MSAL.PS

# $tenantId = "fbd5b602-423c-4722-be67-8382bc9dc8fa"   # tenantID (Azure Directory ID) were AppSP resides
# $clientId = "8f7e4b2a-e5ef-4267-ada6-c7c63479ba12"   # AppID also ClientID for AppSP     
# $clientSecret = "???"   # Client secret for AppSP 
# $scopes = "https://database.windows.net/.default" # The end-point

# $result = Get-MsalToken -RedirectUri $uri -ClientId $clientId -ClientSecret (ConvertTo-SecureString $clientSecret -AsPlainText -Force) -TenantId $tenantId -Scopes $scopes

# $Tok = $result.AccessToken
# #Write-host "token"
# $Tok

# $SQLServerName = "servermaster"    # Azure SQL logical server name 
# $DatabaseName = "database01"     # Azure SQL database name

# Set-AzSqlServer -ResourceGroupName "Shell" -ServerName "servermaster" -AssignIdentity


# Write-Host "Create SQL connection string"
# $conn = New-Object System.Data.SqlClient.SQLConnection 

# $conn.ConnectionString = "Data Source=$SQLServerName.database.windows.net;Initial Catalog=$DatabaseName;Connect Timeout=100"
# $conn.AccessToken = $Tok

# Write-host "Connect to database and execute SQL script"
# $conn.Open() 
# $ddlstmt = 
# 'CREATE USER [GROUPE AD] FROM EXTERNAL PROVIDER'
  
# -- add user to role(s) in db 
# ALTER ROLE db_ddladmin ADD MEMBER [GROUPE AD]; 
# ALTER ROLE db_datawriter ADD MEMBER [GROUPE AD];'

# Write-host " "
# Write-host "SQL DDL command"
# $ddlstmt
# $command = New-Object -TypeName System.Data.SqlClient.SqlCommand($ddlstmt, $conn)       

# Write-host "results"
# $command.ExecuteNonQuery()
# $conn.Close()

# $SQLServerName = "servermaster"    # Azure SQL logical server name 
# $DatabaseName = "database02"     # Azure SQL database name

# Write-Host "Create SQL connection string"
# $conn = New-Object System.Data.SqlClient.SQLConnection 
# Set-AzSqlServer -ResourceGroupName "Shell" -ServerName "servermaster" -AssignIdentity
# $conn.ConnectionString = "Data Source=$SQLServerName.database.windows.net;Initial Catalog=$DatabaseName;Connect Timeout=100"
# $conn.AccessToken = $Tok

# Write-host "Connect to database and execute SQL script"
# $conn.Open() 
# $ddlstmt = 
# 'CREATE USER [GROUPE AD] FROM EXTERNAL PROVIDER'
  
# -- add user to role(s) in db 
# ALTER ROLE db_ddladmin ADD MEMBER [GROUPE AD]; 
# ALTER ROLE db_datawriter ADD MEMBER [GROUPE AD];'


# Write-host " "
# Write-host "SQL DDL command"
# $ddlstmt
# $command = New-Object -TypeName System.Data.SqlClient.SqlCommand($ddlstmt, $conn)       

# Write-host "results"
# $command.ExecuteNonQuery()
# $conn.Close()

############################################TDE####################################################
############################################TDE####################################################

# When this will be supported, there should be the set of this key for TDE
# For now this step will be done using powershell
# resource "null_resource" "sql_setkey" {
#   provisioner "local-exec" {
#     command = <<EOT
#     $ErrorActionPreference = "Stop"
#     $cnt = 0
#     $Delay = 15000
#     $Maximum = 3
#     $TenantId = (Get-Item "env:ARM_TENANT_ID").Value
#     if(Test-Path env:ARM_CLIENT_ID) {
#       $ServicePrincipalId = (Get-Item "env:ARM_CLIENT_ID").Value
#       $ServicePrincipalPwd = (Get-Item "env:ARM_CLIENT_SECRET").Value
#       $passwd = ConvertTo-SecureString $ServicePrincipalPwd -AsPlainText -Force
#       $pscredential = New-Object System.Management.Automation.PSCredential($ServicePrincipalId, $passwd)
#       Disable-AzContextAutosave -Scope Process
#       Connect-AzAccount -Scope Process -ServicePrincipal -Credential $pscredential -Tenant $tenantId -Subscription ${data.azurerm_subscription.current.subscription_id} -ContextName sql_setkey-${var.name}
#     }
#    else {
#       Write-Host "Using AAD authentication..."
#       $context = Get-AzContext
#       if (!$context -or ($context.Subscription.Id -ne '${data.azurerm_subscription.current.subscription_id}')) {
#         throw 'Execution failed: No authentication, you need to use ARM_CLIENT_ID and AMR_CLIENT_SECRET env variables or connect with your AAD account using Connect-AzAccount'
#       }
#     }
#     do {
#       $cnt++
#       try {
#         Add-AzSqlServerKeyVaultKey -ResourceGroupName ${var.resource_group_name} -ServerName ${var.name} -KeyId ${azurerm_key_vault_key.sql_tde_key.id}
#         Set-AzSqlServerTransparentDataEncryptionProtector -ResourceGroupName ${var.resource_group_name} -ServerName ${var.name} -Type AzureKeyVault -KeyId ${azurerm_key_vault_key.sql_tde_key.id} -Force 
#         if(Test-Path env:ARM_CLIENT_ID) {
#           Disconnect-AzAccount -ContextName sql_setkey-${var.name} -Scope Process
#         }
#         return
#       }
#       catch [Exception]
#       {
#         Write-Host $_.Exception.Message
#         Start-Sleep -Milliseconds $Delay
#       }
#     } while ($cnt -lt $Maximum)
#     if(Test-Path env:ARM_CLIENT_ID) {
#       Disconnect-AzAccount -ContextName sql_setkey-${var.name} -Scope Process
#     }
#     throw 'Execution failed.'
#     EOT
#     on_failure = fail
#     interpreter = ["PowerShell", "-Command"]
#   }

#   depends_on = [
#     azurerm_sql_server.sql_server,
#   ]
# }

# resource "azurerm_mssql_server_extended_auditing_policy" "extended_policy" {
#   server_id                               = azurerm_sql_server.sql_server.id
#   storage_endpoint                        = var.storage_endpoint
#   storage_account_access_key              = var.storage_account_access_key
#   storage_account_access_key_is_secondary = false
#   retention_in_days                       = 6
# }

# resource "azurerm_key_vault_key" "sql_tde_key" {
#   name                            = var.sql_tde_key
#   key_vault_id                    = var.key_vault_id
#   key_type                        = "RSA"
#   key_size                        = 2048
#   key_opts                        = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
# }

#${azurerm_key_vault_key.sql_vault_key[0].id}
# END

# resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
#   for_each = var.subnets
#     name                = each.key
#     resource_group_name = var.resource_group_name
#     server_name         = azurerm_sql_server.sql_server.name
#     subnet_id           = each.value.id
# }
