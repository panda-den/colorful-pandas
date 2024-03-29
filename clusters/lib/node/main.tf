terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}

locals {
  name = "${var.node_location}-${random_string.slug.id}"
}

resource "random_string" "slug" {
  length  = 5
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "hcloud_server" "node" {
  name = local.name

  image              = var.image_id
  server_type        = var.node_type
  location           = var.node_location
  placement_group_id = var.placement_group_id

  labels    = var.labels
  user_data = var.user_data

  lifecycle {
    ignore_changes = [
      image,
      user_data
    ]
  }
}

resource "hcloud_server_network" "subnet" {
  server_id = hcloud_server.node.id
  subnet_id = var.subnet_id
}

resource "hcloud_rdns" "v4" {
  server_id  = hcloud_server.node.id
  ip_address = hcloud_server.node.ipv4_address
  dns_ptr    = format("%s.%s", local.name, var.rdns_domain)
}

resource "hcloud_rdns" "v6" {
  server_id  = hcloud_server.node.id
  ip_address = hcloud_server.node.ipv6_address
  dns_ptr    = format("%s.%s", local.name, var.rdns_domain)
}
