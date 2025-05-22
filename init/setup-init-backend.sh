set -e

create_terraform_backend() {
    local env=$1
    local location=$2
    local rg_name="rg-openmrscore-${env}"
    local sa_name="openmrscore${env}sav1"
    local container_name="tfstate-${env}"
    
    echo "====== Configuration Backend Terraform pour l'environnement $env ======"
    
    echo "🔄 Création du Resource Group $rg_name..."
    az group create --name "$rg_name" --location "$location" --tags "Environment=$env" "Purpose=TerraformState"
    echo "✅ Resource Group $rg_name créé."
    
    echo "🔄 Création du Storage Account $sa_name..."
    az storage account create \
        --name "$sa_name" \
        --resource-group "$rg_name" \
        --location "$location" \
        --sku "Standard_LRS" \
        --kind "StorageV2" \
        --https-only true \
        --min-tls-version "TLS1_2" \
        --tags "Environment=$env" "Purpose=TerraformState"
    echo "✅ Storage Account $sa_name créé."
    
    echo "🔄 Création du Container $container_name..."
    az storage container create \
        --name "$container_name" \
        --account-name "$sa_name" \
        --auth-mode login
    echo "✅ Container $container_name créé."

}

if ! az account show > /dev/null 2>&1; then
  echo "🔐 Vous n'êtes pas connecté à Azure CLI. Connexion..."
  az login
else
  echo "✅ Déjà connecté à Azure CLI."
fi

LOCATION="francecentral"

echo -e "\n🏗️  CRÉATION DES BACKENDS TERRAFORM"
DEV_BACKEND=$(create_terraform_backend "dev" "$LOCATION")
PROD_BACKEND=$(create_terraform_backend "prod" "$LOCATION")