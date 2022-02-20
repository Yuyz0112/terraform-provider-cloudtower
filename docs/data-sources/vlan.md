---
# generated by https://github.com/hashicorp/terraform-plugin-docs
page_title: "cloudtower_vlan Data Source - terraform-provider-cloudtower"
subcategory: ""
description: |-
  CloudTower vlan data source.
---

# cloudtower_vlan (Data Source)

CloudTower vlan data source.



<!-- schema generated by tfplugindocs -->
## Schema

### Optional

- **cluster_id** (String) filter vlans by cluster id
- **id** (String) The ID of this resource.
- **name** (String) filter vlans by name
- **name_contains** (String) filter vlans by name contain a certain string
- **type** (String) filter vlans by type

### Read-Only

- **vlans** (List of Object) list of vlans (see [below for nested schema](#nestedatt--vlans))

<a id="nestedatt--vlans"></a>
### Nested Schema for `vlans`

Read-Only:

- **id** (String)
- **name** (String)
- **type** (String)

