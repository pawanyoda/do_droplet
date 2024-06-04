output "droplet_ip" {
  description = "The IP address of the Droplet"
  value       = digitalocean_droplet.droplet.ipv4_address
}