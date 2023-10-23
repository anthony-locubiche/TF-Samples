#Storage Account Key where tfstates is stored
#All the other settings related to the backend are defined in backend.tf
$env:ARM_ACCESS_KEY = "0NP3fT+lx3abB316iFak3EOFehDrPJ6EVV6q+e2xaDruy8PkrU6mw5x51P2kci+vpPBNBAIb6tDl+AStgbYIsA=="
$env:ARM_TENANT_ID  = "cf36141c-ddd7-45a7-b073-111f66d0b30c"
terraform version
terraform init -upgrade #Fix the version of providers in provider.tf
terraform plan -var-file="env_sandbox.tfvars" -out sandbox.tfplan
#terraform apply -input=false -lock-timeout=2m .\sandbox.tfplan