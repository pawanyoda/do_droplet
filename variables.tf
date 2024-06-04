variable "do_token" {
  default     = ""
  description = "DO Token"
  type        = string
  sensitive   = true
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "Dev"
}

variable "region" {
  description = "Region to create the Droplet in"
  type        = string
  default     = "spg1"
}

variable "droplet_size" {
  description = "Droplet size"
  type        = string
  default     = "s-4vcpu-8gb"
}

variable "ssh_key_name" {
  default     = "dev-key"
  description = "Name of the SSH key to use"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private SSH key"
  type        = string
  default     = "./rsa.pub"
}

variable "tf_spaces_access_id" {
  description = "Tf access key to use for state file save"
  type = string
  default = ""
}

variable "tf_spaces_secret_id" {
  description = "Tf secret key to use for state file save"
  type = string
  default = ""
}

variable "flatcar_stable_version" {
  default     = "3815.2.2"
  type        = string
  description = "The Flatcar Stable release you want to use for the initial installation, e.g., 2608.13.0"
}

variable "docr_namespace" {
  description = "Provide DO Registry Namespace"
  type        = string
  default     = "test"
}

variable "workspace" {
  description = "Define the workspace"
  type = string
  default = "dev"
}

variable "environment" {
  description = "Define the environment"
  default = ""
}

variable "inventory" {
  description = "Define the inventory"
  default = ""
}


variable "tfe_token" {
  type      = string
  sensitive = true
}

resource "tfe_variable" "env" {
  key          = "environment"
  value        = "dev"
  category     = "terraform"
  workspace_id = tfe_workspace.test.id
}


resource "tfe_workspace" "test" {
  name         = "droplet"
  organization = "test"
}