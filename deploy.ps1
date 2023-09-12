$REPO_ROOT_PATH        = "C:\Users\anthony.locubiche\OneDrive - Avanade\Project\Dev\TF-Samples"
$ENV_BRANCH_NAME       = "sandbox"
$TFSTATE_FILENAME_ROOT = "C:\Users\anthony.locubiche\OneDrive - Avanade\Project\Dev\TF-Samples\tfstates\sandbox"
$CONTAINER_NAME        = "tfstates"
$STORAGE_ACCOUNT_NAME  = "deployment"
$FOLDER_NAME           = "tfstates"
$env:ARM_ACCESS_KEY = "0NP3fT+lx3abB316iFak3EOFehDrPJ6EVV6q+e2xaDruy8PkrU6mw5x51P2kci+vpPBNBAIb6tDl+AStgbYIsA=="
$AZURE_SUBSCRIPTION_ID = ""
echo 'Terraform version'
C:\Tools\terraform_1.5.7_windows_386\terraform.exe version
echo "$ENV_BRANCH_NAME environment variables set"
echo 'Terraform init'
C:\Tools\terraform_1.5.7_windows_386\terraform.exe init -upgrade -backend-config "key=$TFSTATE_FILENAME_ROOT/$FOLDER_NAME.tfstate" -backend-config storage_account_name=$STORAGE_ACCOUNT_NAME -backend-config container_name=$CONTAINER_NAME -backend-config sas_token=$SAS_TOKEN -no-color -input=false
echo 'Terraform plan'
C:\Tools\terraform_1.5.7_windows_386\terraform.exe plan -var-file="$REPO_ROOT_PATH/variables.tfvars"



terraform init -backend-config "storage_account_name=sandboxtflogs" -backend-config "container_name=sandbox" -backend-config "key=sandbox.tfstate" -backend-config "resource_group_name=sandbox-terraform-demo" -backend-config "sas_token='sp=r&st=2023-09-11T14:57:19Z&se=2023-09-11T22:57:19Z&spr=https&sv=2022-11-02&sr=c&sig=lgWbqsTVzO8KOSlKOzMBYOlk7prcKVgq5tml4t%2BBGy4%3D}}'"

