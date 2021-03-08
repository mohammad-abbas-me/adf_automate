# -------------------
# User Authorization

variable "homeTenantId" {
    default = "e1df1cdc-b741-470d-b864-90f2feb83888"
}

variable "id" {
    default = "3144fe43-cdc2-4b56-af79-50b2d12f8c40"
}

variable "tenantId" {
    default = "e1df1cdc-b741-470d-b864-90f2feb83888"
}
# -------------------

# -----------------
# Azure Services names

variable "name" {
	default = "adf_test"
}

variable "location"{
	default = "eastus"
}

variable "resource_group_name" {
    description = "Azure resource group name"
    default = "resource_group_mohammad"
}

variable "data_factory_name"{
    description = "Azure Data Factory name"
    default = "adfdatafactorytestmohamad"
}

variable "storage_account_name"{
    description = "Azure blob storage account name"
    default = "adfblobstoragetest1"
}

variable "storage_container_name"{
    description = "Azure storage container name"
    default = "adfstoragecontainertest"
}

variable "storage_blob_name"{
    description = "Azure blob storage name"
    default = "adf_storage_blob_test.zip"
}

variable "linked_blob_storage_name"{
    description = "Data factory linked service with blob storage"
    default = "adf_linked_storage_test"
}

variable "dataset_blob_storage_name"{
    description = "Data factory dataset blob storage"
    default = "adf_dataset_test"
}

variable "pipeline_name"{
    description = "Data factory pipeline"
    default = "adf_pipeline_test1"
}
# -------------------

# -------------------
# Github Configuration

variable "github_account_name"{
    description = "Github user account name"
    default = "mohammad-abbas-me"
}

variable "github_branch_name" {
    description = "Github branch name"
    default = "adf_dev"
}

variable "github_git_url" {
    description = "Github git url"
    default = "https://github.com"
}

variable "github_repo_name" {
    description = "Github repo name"
    default = "adf_automate"
}

variable "github_root_dir" {
    description = "Github root folder name"
    default =  "/adf_artifacts"
}
# -------------------
