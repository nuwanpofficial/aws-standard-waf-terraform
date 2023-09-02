variable "environment" {
  description = "Kindly provide name of the environment eg: prod/dev"
  type        = string
  default     = "rnd"
}

variable "product" {
  description = "Name of the product which the infra is used"
  type        = string
  default     = "ticketing"
}

variable "aws_region" {
  description = "AWS Region which resources are going to be deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Provide AWS Credential Profile Name"
  type        = string
  default     = "default"
}

variable "rg_short" {
  description = "AWS Region short name eg: If us-east-1; use1"
  type        = string
  default     = "use1"
}

variable "application" {
  description = "Application name which the infra will be used"
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "Project name which the infra will be used"
  type        = string
  nullable    = false
}

variable "ticket_id" {
  description = "Jira ticket ID which the infra will be used"
  type        = string
  nullable    = false
}


variable "creator" {
  description = "Provide the email id of the executing user"
  type        = string
  nullable    = false
  validation {
    condition     = !(length(var.creator) > 15 && contains(["@testing.com"], var.creator))
    error_message = "Please provide your email for the creator variable"
  }
}

variable "s3_data_retentions_days" {
  description = "No of days that the s3 objects needs to be kept before deletion"
  type        = number
}

variable "waf_rate_limit" {
  description = "No of allowed request from an IP per 5 mins time period"
  type        = number
}

variable "block_countries" {
  description = "Provide the list of Countries that needs to be blocked"
  type        = list(string)
}

variable "block_ips" {
  description = "Provide the list of IPs that needs to be blocked"
  type        = list(string)
}

variable "allow_ips" {
  description = "Provide the list of IPs that needs to be allowed specifically"
  type        = list(string)
}
