terraform {
  required_providers {
    cloudtower = {
      version = "~> 0.1.4"
      source  = "registry.terraform.io/Yuyz0112/cloudtower"
    }
  }
}

provider "cloudtower" {
  username          = "root"
  user_source       = "LOCAL"
  cloudtower_server = "terraform.dev-cloudtower.smartx.com"
}

data "cloudtower_datacenter" "sample_dc" {}

resource "cloudtower_cluster" "sample_cluster" {
  ip            = "192.168.17.39"
  username      = "root"
  password      = "tower2022"
  datacenter_id = data.cloudtower_datacenter.sample_dc.datacenters[0].id
}

data "cloudtower_vlan" "vm_vlan" {
  name       = "default"
  type       = "VM"
  cluster_id = cloudtower_cluster.sample_cluster.id
}

data "cloudtower_iso" "ubuntu" {
  name_contains = "ubuntu"
  cluster_id    = cloudtower_cluster.sample_cluster.id
}

data "cloudtower_host" "target_host" {
  management_ip_contains = "17.42"
  cluster_id             = cloudtower_cluster.sample_cluster.id
}

resource "cloudtower_vm" "tf_test" {
  name                = "tf-test"
  description         = "managed by terraform"
  cluster_id          = cloudtower_cluster.sample_cluster.id
  host_id             = data.cloudtower_host.target_host.hosts[0].id
  vcpu                = 4
  memory              = 8 * 1024 * 1024 * 1024
  ha                  = true
  firmware            = "BIOS"
  status              = "STOPPED"
  force_status_change = true

  cd_rom {
    boot   = 1
    iso_id = data.cloudtower_iso.ubuntu.isos[0].id
  }


  disk {
    boot = 2
    bus  = "VIRTIO"
    vm_volume {
      storage_policy = "REPLICA_2_THIN_PROVISION"
      name           = "d1"
      size           = 10 * 1024 * 1024 * 1024
    }
  }

  disk {
    boot = 3
    bus  = "VIRTIO"
    vm_volume {
      storage_policy = "REPLICA_3_THICK_PROVISION"
      name           = "d2"
      size           = 1 * 1024 * 1024 * 1024
    }
  }

  cd_rom {
    boot   = 4
    iso_id = ""
  }

  nic {
    vlan_id = data.cloudtower_vlan.vm_vlan.vlans[0].id
  }
}
