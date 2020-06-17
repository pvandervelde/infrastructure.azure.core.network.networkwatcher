terraform {
  backend "local" {
  }
}

provider "azurerm" {
  alias  = "production"

  features {}

  subscription_id = var.subscription_production

  version = "~>2.12.0"
}

provider "azurerm" {
    alias = "target"

    features {}

    subscription_id = var.environment == "production" ? var.subscription_production : var.subscription_test

    version = "~>2.12.0"
}

#
# LOCALS
#

locals {
  location_map = {
    australiacentral   = "auc",
    australiacentral2  = "auc2",
    australiaeast      = "aue",
    australiasoutheast = "ause",
    brazilsouth        = "brs",
    canadacentral      = "cac",
    canadaeast         = "cae",
    centralindia       = "inc",
    centralus          = "usc",
    eastasia           = "ase",
    eastus             = "use",
    eastus2            = "use2",
    francecentral      = "frc",
    francesouth        = "frs",
    germanynorth       = "den",
    germanywestcentral = "dewc",
    japaneast          = "jpe",
    japanwest          = "jpw",
    koreacentral       = "krc",
    koreasouth         = "kre",
    northcentralus     = "usnc",
    northeurope        = "eun",
    norwayeast         = "noe",
    norwaywest         = "now",
    southafricanorth   = "zan",
    southafricawest    = "zaw",
    southcentralus     = "ussc",
    southeastasia      = "asse",
    southindia         = "ins",
    switzerlandnorth   = "chn",
    switzerlandwest    = "chw",
    uaecentral         = "aec",
    uaenorth           = "aen",
    uksouth            = "uks",
    ukwest             = "ukw",
    westcentralus      = "uswc",
    westeurope         = "euw",
    westindia          = "inw",
    westus             = "usw",
    westus2            = "usw2",
  }
}

locals {
  environment_short = substr(var.environment, 0, 1)
  location_short    = lookup(local.location_map, var.location, "aue")
}

# Name prefixes
locals {
  name_prefix    = "${local.environment_short}-${local.location_short}"
  name_prefix_tf = "${local.name_prefix}-tf-${var.category}"
}

locals {
  common_tags = {
    category    = "${var.category}"
    environment = "${var.environment}"
    location    = "${var.location}"
    source      = "${var.meta_source}"
    version     = "${var.meta_version}"
  }

  extra_tags = {
  }
}

#
# Network watcher
# Following Azure naming standard to not create twice
#

resource "azurerm_resource_group" "netwatcher" {
  count    = 1
  name     = "NetworkWatcherRG"
  location = var.location

  provider = azurerm.target

  tags = merge( local.common_tags, local.extra_tags, var.tags )
}

resource "azurerm_network_watcher" "netwatcher" {
  count               = 1
  name                = "NetworkWatcher_${local.location_short}"
  location            = var.location
  resource_group_name = azurerm_resource_group.netwatcher.0.name

  provider = azurerm.target

  tags = merge( local.common_tags, local.extra_tags, var.tags )
}
