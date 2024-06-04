#resource "digitalocean_custom_image" "flatcar" {
#  name   = "flatcar-stable-${var.flatcar_stable_version}"
#  url    = "https://stable.release.flatcar-linux.net/amd64-usr/${var.flatcar_stable_version}/flatcar_production_digitalocean_image.bin.bz2"
#  regions = [var.region]
#}

#
data "digitalocean_image" "image" {
  name = "img"
}

data "digitalocean_vpc" "vpc" {
  name = "vpc"
}

resource "digitalocean_droplet" "droplet" {
  vpc_uuid = data.digitalocean_vpc.vpc.id
  image    = data.digitalocean_image.image.id
  name     = var.droplet_name
  region   = var.region
  #  monitoring        = true
  #  user_data = file("yaml/cloud-config.yaml")
  user_data              = <<-EOF
              #!/bin/bash
              touch ~/flatcar_file
              docker run -d --name alpine-test alpine tail -f /dev/null

              EOF
  #  ssh_keys = [for key in data.digitalocean_ssh_key.ssh_key : key.id]
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]

  size = var.droplet_size


  lifecycle {
    create_before_destroy = true
  }

  tags = [var.droplet_name, var.region]
}


data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

resource "digitalocean_firewall" "droplet_firewall" {
  name = "block-port-access"

  # The droplet that the firewall is tied to
  droplet_ids = [digitalocean_droplet.droplet.id]

  # Inbound SSH rule for Github Actions runner
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }


  inbound_rule {
  protocol         = "tcp"
  port_range       = "3000"
  source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
  protocol         = "tcp"
  port_range       = "5000"
  source_addresses = ["0.0.0.0/0"]
  }


  # Outbound TCP rule allowing all access (for Discord text)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound UDP rule allowing all access (for Discord audio/video)
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound ICMP rule allowing all access
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}