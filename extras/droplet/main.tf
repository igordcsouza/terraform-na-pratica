# Create a web server
resource "digitalocean_droplet" "workstation" {
  image  = "centos-7-x64"
  name   = "TPN"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["35:46:8e:d2:33:5d:27:ce:84:c5:8b:6a:e1:30:aa:50"] 
#   user_data = "#cloud-config\npackages:\n - python"


}


output "workstation_ip" {
  value = "${digitalocean_droplet.workstation.ipv4_address}"
}

