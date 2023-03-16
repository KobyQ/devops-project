variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
  default     = "eastus"
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
  default     = "devops-project"
}

variable "principal_id" {
  description = "The Id of the azd service principal to add to deployed keyvault access policies"
  type        = string
  default     = ""
}