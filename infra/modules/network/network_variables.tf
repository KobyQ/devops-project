variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "app_id" {
  description = "The id of the azure web app."
  type        = string
}

variable "private_connection_resource_id" {
  description = "The id of the resource for private connection"
  type        = string
}