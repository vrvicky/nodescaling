provider "ibm" {}

variable "public_ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
}

variable "datacenter" {
  description = "Softlayer datacenter where infrastructure resources will be deployed"
  default = "sng01"
}

variable "first_hostname" {
  description = "Hostname of the first virtual instance (small flavor) to be deployed"
  default     = "virtualserver04"
}

variable "domain" {
  description = "VM domain"
  default="ICAMNodescaling.cloud"
}


# This will create a new SSH key that will show up under the \
# Devices>Manage>SSH Keys in the SoftLayer console.
resource "ibm_compute_ssh_key" "orpheus_public_key" {
  label      = "Orpheus Public Key"
  public_key = "${var.public_ssh_key}"
}

#data "ibm_compute_image_template" "UBUNTU_16_04_64" {
  
 # name = "25GB - Ubuntu / Ubuntu / 16.04-64 Minimal for VSI"
#}

# Create a new virtual guest using image "UBUNTU"
resource "ibm_compute_vm_instance" "UBUNTU" {
  hostname                 = "${var.first_hostname}"
 # image_id                 = 1670837
 os_reference_code        = "UBUNTU_16_64"
  domain                   = "${var.domain}"
  datacenter               = "${var.datacenter}"
  #network_speed            = 10
  hourly_billing           = true
  private_network_only     = false
 # cores                    = 8
 #memory                   = 16384
  cores                    = 2
 memory                   = 2048
 disks                    = [25, 250]
  user_metadata            = "{\"value\":\"newvalue\"}"
  dedicated_acct_host_only = false
  local_disk               = false
  ssh_key_ids              = ["${ibm_compute_ssh_key.orpheus_public_key.id}"]
}

# Create a new virtual guest using image "Ubuntu"
output "debian_vm_ip" {
  value = "Public : ${ibm_compute_vm_instance.UBUNTU.ipv4_address}"
}

