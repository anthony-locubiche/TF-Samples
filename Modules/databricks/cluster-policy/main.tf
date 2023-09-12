terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

locals {
  default_job_policy = {
    "cluster_type": {
      "type": "fixed",
      "value": "job"
    },
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 100
    },
    "instance_pool_id": {
      "type": "forbidden",
      "hidden": true
    },
    "spark_version": {
      "type": "regex",
      "pattern": "8\\.[0-9]+\\.x-scala.*"
    },
    "node_type_id": {
      "type": "allowlist",
      "values": [
        "Standard_D4s_v3",
        "Standard_D8s_v3"
      ],
      "defaultValue": "Standard_D4s_v3"
    },
    "driver_node_type_id": {
      "type": "allowlist",
      "values": [
        "Standard_D4s_v3",
        "Standard_D8s_v3"
      ],
      "defaultValue": "Standard_D4s_v3"
    },
    "autoscale.min_workers": {
      "type": "range",
      "minValue": 0,
      "maxValue": 15,
      "defaultValue": 1
    },
    "autoscale.max_workers": {
      "type": "range",
      "maxValue": 15,
      "defaultValue": 2
    },
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 30,
      "hidden" : true
    }
#    "custom_tags.ST-App-Name" : {
#      "type" : "fixed",
#      "value" : "MDA Semantic" #var.group_name
#    },
#    "custom_tags.ST-Env-Type" : {
#      "type" : "fixed",
#      "value" : var.environment
#    },
#    "custom_tags.ST-Owner-Org" : {
#      "type" : "fixed",
#      "value" : "DIT"
#    },
#    "custom_tags.ST-Owner-SubOrg" : {
#      "type" : "fixed",
#      "value" : "MDA"
#    },
#    "custom_tags.ST-Owner" : {
#      "type" : "fixed",
#      "value" : "hugues.duverneuil@st.com"
#    },
#    "custom_tags.ST-SOX" : {
#      "type" : "fixed",
#      "value" : "FALSE"
#    },
#    "custom_tags.ST-Security-Rating" : {
#      "type" : "fixed",
#      "value" : "H"
#    },
#    "custom_tags.ST-Ops-Org" : {
#      "type" : "fixed",
#      "value" : "DIT MDA"
#    },
#    "custom_tags.ST-Ops-Org-Owner" : {
#      "type" : "fixed",
#      "value" : "DIT MDA"
#    },
#    "custom_tags.ST-Ops-ARTP-Model" : {
#      "type" : "fixed",
#      "value" : "Scheduling and application"
#    },
#    "custom_tags.ST-Data-Classification" : {
#      "type" : "fixed",
#      "value" : "ST Confidential"
#    },
#    "custom_tags.ST-Resource-Manager" : {
#      "type" : "fixed",
#      "value" : "Terraform"
#    }
  }
}

resource "databricks_cluster_policy" "job_policy" {
  provider = databricks
  name       = var.policy_name
  definition = jsonencode(merge(local.default_job_policy, var.policy_overrides))
}

resource "databricks_permissions" "job_policy_permissions" {
  provider = databricks
  cluster_policy_id = databricks_cluster_policy.job_policy.id

  #Create as many 'access_control' blocks as there are in var.access_controls
  dynamic "access_control" {
    for_each = var.access_controls
    content {
      group_name       = access_control.value["group_name"]       #i.e: users
      permission_level = access_control.value["permission_level"] #i.e: CAN_USE
    }
  }
}