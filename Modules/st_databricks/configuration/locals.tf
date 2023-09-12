locals {
  admin_users_object_id = flatten([
    for group in data.azuread_group.admin_groups : [
      for user_object_id in group.members : [
        user_object_id
      ]
    ]
  ])
  users_object_id = flatten([
    for group in data.azuread_group.user_groups : [
      for user_object_id in group.members : [
        user_object_id
      ]
    ]
  ])
}