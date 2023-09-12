locals {
  users_object_id = flatten([
    for group in data.azuread_group.groups : [
      for user_object_id in group.members : [
        user_object_id
      ]
    ]
  ])
}