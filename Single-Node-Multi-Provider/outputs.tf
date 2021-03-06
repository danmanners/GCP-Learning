output "digitalocean_droplet_ips" {
  value = module.do_droplets.ipv4
}

output "google_cloud_ips" {
  value = module.google_cloud_compute.ipv4
}

output "aws_cloud_ips" {
  value = module.aws_compute.ipv4
}
