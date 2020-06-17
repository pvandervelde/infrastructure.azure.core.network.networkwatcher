#
# ENVIRONMENT
#

variable "category" {
    default = "nwk-watcher"
    description = "The name of the category that all the resources are running in."
}

variable "environment" {
    default = "production"
    description = "The name of the environment that all the resources are running in."
}

#
# LOCATION
#

variable "location" {
    default = "australiaeast"
    description = "The full name of the Azure region in which the resources should be created."
}

#
# META
#

variable "meta_source" {
    description = "The commit ID of the current commit from which the plan is being created."
    type = string
}

variable "meta_version" {
    description = "The version of the infrastructure as it is being generated."
    type = string
}

#
# SUBSCRIPTIONS
#

variable "subscription_production" {
    description = "The subscription ID of the production subscription. Used to find the log analytics resources."
    type = string
}

variable "subscription_test" {
    description = "The subscription ID of the test subscription."
    type = string
}

#
# TAGS
#

variable "tags" {
    description = "Tags to apply to all resources created."
    type = map(string)
    default = { }
}