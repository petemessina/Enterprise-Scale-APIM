variable "workload_name" {
  type        = string
  description = "A short name for the workload being deployed"
  default     = "apim"
  validation {
    condition = (
      can(regex("^[a-zA-Z0-9]{3,8}$", var.workload_name))
    )
    error_message = "Please enter a valid value (alphanumberic no spaces less than 8 chars)."
  }
}

variable "deployment_environment" {
  type        = string
  description = "The environment for which the deployment is being executed"
  default     = "dev"

  validation {
    condition     = contains(["dev", "uat", "prod", "dr"], var.deployment_environment)
    error_message = "Valid values for var: deployment_environment are (dev, uat, prod, dr)."
  }
}

variable "location" {
  type        = string
  description = "The location in which the deployment is happening"
  default     = "East US"
  validation {
    condition = anytrue([
      var.location == "East US",
      var.location == "West US"
    ])
    error_message = "Please enter a valid Azure Region."
  }
}