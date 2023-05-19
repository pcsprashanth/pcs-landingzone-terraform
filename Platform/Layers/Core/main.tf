# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}


##### Module for Subscriptions #########

#module "subscription" {
#  source = "../../../Modules/modules/subscription"
#  subscriptions = var.subscriptions
#}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.0.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm         
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path = "./lib"


  ###### Deploys MG structure with naming convention provided by customer and disables deployment of default core structure ######

  deploy_core_landing_zones = false

  custom_landing_zones = {
      "${var.root_id}" = {
        display_name               = "${lower(var.root_name)}"
        parent_management_group_id = "${data.azurerm_client_config.core.tenant_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_root"
          parameters     = {}
          access_control = {}
        }
       } 
      "${var.root_id}-platform" = {
        display_name               = "Platform"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-landingzones" = {
        display_name               = "Landing Zones"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-decom" = {
        display_name               = "Decommissioned"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.connectivity1,azurerm_subscription.connectivity2]
      }
      "${var.root_id}-sandbox" = {
        display_name               = "Sandbox"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_sandboxes"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.management1]
      }
      "${var.root_id}-iam" = {
        display_name               = "Identity and Access Managment"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.identity1]
      }
      ##### landing zone #####
      "${var.root_id}-management" = {
        display_name               = "Management"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-connectivity" = {
        display_name               = "Connectivity"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-secops" = {
        display_name               = "Security Operations"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-prod" = {
        display_name               = "Prod"
        parent_management_group_id = "${var.root_id}-landingzones"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-dev" = {
        display_name               = "Dev"
        parent_management_group_id = "${var.root_id}-landingzones"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-homol" = {
        display_name               = "Homol"
        parent_management_group_id = "${var.root_id}-landingzones"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
    }
}
data "azurerm_management_group" "parent" {
  display_name = "itaudev"
}

resource "azurerm_management_group_policy_assignment" "asb" {
  name                   = "Cloud-BenchMark"
  management_group_name  = data.azurerm_management_group.parent.id
  policy_definition_id   = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  description            = "The Azure Security Benchmark initiative represents the policies and controls implementing security recommendations defined in Azure Security Benchmark v3, see https://aka.ms/azsecbm. This also serves as the Microsoft Defender for Cloud default policy initiative. You can directly assign this initiative, or manage its policies and compliance results within Microsoft Defender for Cloud."
  display_name           = "Microsoft Cloud Security Benchmark"
  enforce                = false
}
