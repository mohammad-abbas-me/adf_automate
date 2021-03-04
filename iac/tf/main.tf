
resource "azurerm_resource_group" "adf_resource_test" {
  name     = "${var.name}_resources_test"
  location = "West Europe"
}


# Azure Data factory resource.
resource "azurerm_data_factory" "adf_data_factory_test1" {
	name = "${var.name}-data-factory-test1"
	location = azurerm_resource_group.adf_resource_test.location
	resource_group_name = azurerm_resource_group.adf_resource_test.name

	github_configuration{
		account_name = "mohammad-abbas-me"
		branch_name = "adf_dev"
		git_url = "https://github.com"
		repository_name = "adf_automate"
		root_filder = "/adf_artifacts"
	}
}

# ===================
# Blob storage.
resource "azurerm_storage_account" "adf_storage_account_test_1" {
  name                     = "${var.name}blobstoragetest1"
  resource_group_name      = azurerm_resource_group.adf_resource_test.name
  location                 = azurerm_resource_group.adf_resource_test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "adf_storage_container_test" {
  name                  = "${var.name}storagecontainertest"
  storage_account_name  = azurerm_storage_account.adf_storage_account_test_1.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "adf_storage_blob_test" {
  name                   = "${var.name}_storage_blob_test.zip"
  storage_account_name   = azurerm_storage_account.adf_storage_account_test_1.name
  storage_container_name = azurerm_storage_container.adf_storage_container_test.name
  type                   = "Block"
  source                 = "main.tf"
}
# ===================

# Linked blob storage with data factory
resource "azurerm_data_factory_linked_service_azure_blob_storage" "adf_linked_storage_test" {
  name                = "${var.name}_linked_storage_test"
  resource_group_name = azurerm_resource_group.adf_resource_test.name
  data_factory_name   = azurerm_data_factory.adf_data_factory_test1.name
  connection_string   = azurerm_storage_account.adf_storage_account_test_1.primary_connection_string
}

# ADF blob dataset
resource "azurerm_data_factory_dataset_azure_blob" "adf_dataset_test" {
  name                = "${var.name}_dataset_test"
  resource_group_name = azurerm_resource_group.adf_resource_test.name
  data_factory_name   = azurerm_data_factory.adf_data_factory_test1.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_linked_storage_test.name

  path     = "foo"
  filename = "main.tf"
}

# ADF Pipeline.
resource "azurerm_data_factory_pipeline" "adf_pipeline_test"{
	name = "${var.name}_pipeline_test"
	resource_group_name = azurerm_resource_group.adf_resource_test.name
	data_factory_name = azurerm_data_factory.adf_data_factory_test1.name
}
