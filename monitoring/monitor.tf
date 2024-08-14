
#  ---------------------------------------------
#  module for azure monitor service
#  ---------------------------------------------

resource "azurerm_monitor_autoscale_setting" "as_conf_for_plan" {
  name = "As_configure_for_app_plan"
  resource_group_name = var.rg_name
  location = var.location
  target_resource_id = var.resource_id

  profile {
    name = "Plan_Profile"
    capacity {
      default = 1
      maximum = 2
      minimum = 1
    }

    rule {
      metric_trigger {
        metric_name = "CpuPercentage"
        metric_resource_id = var.resource_id
        operator = "GreaterThanOrEqual"
        statistic = "Average" 
        time_aggregation = "Average"
        time_grain = "PT5M"
        time_window = "PT20M"
        threshold = 90
      }
      scale_action {
        type = "ChangeCount"
        direction = "Increase"
        value = 1
        cooldown = "PT10M" 
      }  
    }

   rule {
      metric_trigger {
        metric_name = "CpuPercentage"
        metric_resource_id = var.resource_id
        operator = "LessThan"
        statistic = "Average" 
        time_aggregation = "Average"
        time_grain = "PT5M"
        time_window = "PT20M"
        threshold = 45
      }
      scale_action {
        type = "ChangeCount"
        direction = "Decrease"
        value = 1
        cooldown = "PT10M" 
      }  
    }
  }
}