
#terraform import azurerm_resource_group.adf_resource_test /subscriptions/8cbfc19a-ed09-496d-8b87-3f3a46f7b9a5/resourceGroups/resource_group_mohammad
resource "azurerm_resource_group" "adf_resource_test" {
 name     = var.resource_group_name
 location = var.location
}

# Azure Data factory resource.
resource "azurerm_data_factory" "adf_data_factory_test1" {
    name = var.data_factory_name
    location = azurerm_resource_group.adf_resource_test.location
    resource_group_name = azurerm_resource_group.adf_resource_test.name

    github_configuration{
        account_name = var.github_account_name
        branch_name = var.github_branch_name
        git_url = var.github_git_url
        repository_name = var.github_repo_name
        root_folder = var.github_root_dir
    }
}

# ===================
# Blob storage.
resource "azurerm_storage_account" "adf_storage_account_test_1" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.adf_resource_test.name
  location                 = azurerm_resource_group.adf_resource_test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "adf_storage_container_test" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.adf_storage_account_test_1.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "adf_storage_blob_test" {
  name                   = var.storage_blob_name
  storage_account_name   = azurerm_storage_account.adf_storage_account_test_1.name
  storage_container_name = azurerm_storage_container.adf_storage_container_test.name
  type                   = "Block"
  source                 = "main.tf"
}
# ===================

# Linked blob storage with data factory
resource "azurerm_data_factory_linked_service_azure_blob_storage" "adf_linked_storage_test" {
  name                = var.linked_blob_storage_name
  resource_group_name = azurerm_resource_group.adf_resource_test.name
  data_factory_name   = azurerm_data_factory.adf_data_factory_test1.name
  connection_string   = azurerm_storage_account.adf_storage_account_test_1.primary_connection_string
}

# ADF blob dataset
resource "azurerm_data_factory_dataset_azure_blob" "adf_dataset_test" {
  name                = var.dataset_blob_storage_name
  resource_group_name = azurerm_resource_group.adf_resource_test.name
  data_factory_name   = azurerm_data_factory.adf_data_factory_test1.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_linked_storage_test.name

  path     = "foo"
  #filename = "main.tf"
}

# ADF Pipeline.
resource "azurerm_data_factory_pipeline" "adf_pipeline_test1"{
    name = var.pipeline_name
    resource_group_name = azurerm_resource_group.adf_resource_test.name
    data_factory_name = azurerm_data_factory.adf_data_factory_test1.name
    variables = {
        "temp" = "Item1"
    }
    # A JSON object that contains the activities that will 
    # be associated with the Data Factory Pipeline.
    activities_json =  <<JSON
    [
        {
            "name": "Append to temp",
            "type": "AppendVariable",
            "dependsOn": [],
            "userProperties": [],
            "typeProperties": {
                "variableName": "temp",
                "value": "Item2"
            }
            
        }
    ]
            
    JSON   
}
