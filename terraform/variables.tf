variable "region" {
  description = "AWS region for the site bucket. CloudFront itself is global."
  type        = string
  default     = "ap-southeast-2"
}

variable "name_prefix" {
  description = "Prefix for resource names. The bucket name also gets the account id appended so it is globally unique."
  type        = string
  default     = "ryan-berlin-site"
}

variable "project" {
  description = "Value of the Project cost-allocation tag."
  type        = string
  default     = "ryan-berlin"
}

variable "environment" {
  description = "Value of the Environment cost-allocation tag (the AWS account's env name)."
  type        = string
  default     = "jarrodfolino"
}
