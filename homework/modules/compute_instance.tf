#---------------------------------------------------
# Create compute instance
#---------------------------------------------------
resource "google_compute_instance" "compute_instance" {
  #count           = "${var.number_of_instances}"
  count = var.enable_attached_disk ? 0 : var.number_of_instances

  project      = var.project_name
  name         = "${lower(var.name)}-ce-${lower(var.environment)}-${count.index + 1}"
  zone         = var.zone
  machine_type = var.machine_type

  allow_stopping_for_update = var.allow_stopping_for_update
  can_ip_forward            = var.can_ip_forward
  #timeouts                  = var.timeouts
  description               = var.description
  deletion_protection       = var.deletion_protection
  min_cpu_platform          = var.min_cpu_platform
  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
  #scratch_disk {
  #    #interface   = "${var.scratch_disk_interface}"
  #}

  boot_disk {
    auto_delete             = var.boot_disk_auto_delete
    device_name             = var.boot_disk_device_name
    disk_encryption_key_raw = var.disk_encryption_key_raw
    initialize_params {
      size  = var.boot_disk_initialize_params_size
      type  = var.boot_disk_initialize_params_type
      image = var.boot_disk_initialize_params_image
    }
  }

  #attached_disk {
  #    source                  = "testua666"
  #    device_name             = "testua666"
  #    mode                    = "READ_WRITE"
  #    disk_encryption_key_raw = "${var.disk_encryption_key_raw}"
  #}

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = var.address

    // alias_ip_range {
    //     ip_cidr_range              = "10.138.0.0/20"
    //     subnetwork_range_name      = ""
    // }

    access_config {
      nat_ip                 = var.nat_ip
      public_ptr_domain_name = var.public_ptr_domain_name
      network_tier           = var.network_tier
    }
    
  }
   
  metadata = {
    enable-oslogin = "TRUE"
    user-data      = <<EOT
#cloud-config
packages: ["ansible"]
write_files:
- path: /etc/ansible/ansible.cfg
  content: |
      [defaults]
      remote_tmp     = /tmp
      local_tmp      = /tmp
runcmd:
- gsutil cp -r ${google_storage_bucket.ansible.url}/ansible /opt
- ansible-playbook /opt/ansible/playbook.yml -t web
EOT
  }


provisioner "local-exec" {
    command = "echo ${self.network_interface.0.access_config.0.nat_ip} >> /home/mehanic/homework/modules/ansible/hosts"
  }

provisioner "local-exec" {
   # command = "echo ${self.network_interface.0.access_config.0.nat_ip} >> private_ips.txt"
    command = "ansible-playbook -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} /home/mehanic/homework/modules/ansible/httpd.yml"
  }

  // metadata  {
  //   sshKeys = "${var.ssh_user}:${var.ssh_key} \n${var.ssh_user1}:${var.ssh_key1}"
  // }
   
  // metadata = {
  //     ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}""
  //   }


  // labels {
  //   name          = "${lower(var.name)}-ce-${lower(var.environment)}-${count.index + 1}"
  //   environment   = lower(var.environment)
  //   orchestration = lower(var.orchestration)
  // }

  // metadata {
   //  ssh-keys = "${var.ssh_user}:${file("${var.public_key_path}")}"
  //   #shutdown-script = "${file("${path.module}/scripts/shutdown.sh")}"
  // }
  
   
  metadata_startup_script = file("${path.module}/${var.install_script_src_path}")
  
//   metadata  {   
//  ssh_authorized_keys =  "root:${file("~/.ssh/id_rsa.pub")}"
//   }
  


//   metadata {
//     ssh_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
//ssh_authorized_keys = "${file()}"
//    # user_data           = "${var.user_data}"
//   }

//   provisioner "file" {
//     source = "var.install_script_dest_path"
//     destination = "var.install_script_dest_path"

//   connection {
//     type = "ssh"
//     user = "root"
//     private_key = "${file("${var.private_key_path}")}"
//     agent = "false"
//   }
// }
   




  // provisioner "file" {
  //       source      = "${var.install_script_src_path}"
  //       destination = "${var.install_script_dest_path}"
  //       connection {
  //         type = "ssh"
  //         host = self.network_interface[0].ip_address
  //         user            = "${var.ssh_user}"
  //         port            = "${var.ssh_port}"
  //         private_key     = "${file("${var.private_key_path}")}"
  //         agent           = false
  //         timeout         = "5m"
  //         agent_identity  = false
  //         insecure        = true
  //       }
  //   }

    // provisioner "remote-exec" {
    //     inline = [
    //       "chmod +x ~/installations.sh",
    //       "cd ~",
    //       "./installations.sh"
    //     ]
    //     connection {
    //         type = "root"
    //         user = "ubuntu"
    //         private_key = "${file("~/.ssh/id_rsa.pub")}"
    //     }

    // }
  
  
  
  #
  #metadata_startup_script = "echo hi > /test.txt"
  #metadata_startup_script = "${file("startup.sh")}"
  #metadata_startup_script = <<SCRIPT
  #    ${file("${path.module}/scripts/install.sh")}
  #SCRIPT

  #provisioner "file" {
  #    source      = "${var.install_script_src_path}"
  #    destination = "${var.install_script_dest_path}"
  #
  #    connection {
  #        type            = "ssh"
  #        user            = "${var.ssh_user}"
  #        port            = "${var.ssh_port}"
  #        private_key     = "${file("${var.private_key_path}")}"
  #        agent           = false
  #        timeout         = "5m"
  #        agent_identity  = false
  #        insecure        = true
  #    }
  #}

  #provisioner "remote-exec" {
  #    connection {
  #        type        = "ssh"
  #        user        = "${var.ssh_user}"
  #        port        = "${var.ssh_port}"
  #        private_key = "${file("${var.private_key_path}")}"
  #        agent       = false
  #        timeout     = "5m"
  #    }
  #
  #    inline = [
  #        "chmod +x ${var.install_script_dest_path}",
  #        "sudo ${var.install_script_dest_path} ${count.index}",
  #    ]
  #}
  #
  #

  tags = [
    "${lower(var.name)}",
    "${lower(var.environment)}",
    "${lower(var.orchestration)}"
  ]
  
  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  scheduling {
    preemptible         = var.scheduling_preemptible
    on_host_maintenance = var.scheduling_on_host_maintenance
    automatic_restart   = var.scheduling_automatic_restart
  }

  #Note: GPU accelerators can only be used with on_host_maintenance option set to TERMINATE.
  guest_accelerator {
    type  = var.guest_accelerator_type
    count = var.guest_accelerator_count
  }

  lifecycle {
    ignore_changes = [
      network_interface,
    ]
    create_before_destroy = true
  }

}
#---------------------------------------------------
# Create compute instance with attached disk
#---------------------------------------------------
resource "google_compute_instance" "compute_instance_with_attached_disk" {
  count = var.enable_attached_disk && length(var.attached_disk_source) > 0 ? var.number_of_instances : 0

  project      = var.project_name
  name         = "${lower(var.name)}-ce-${lower(var.environment)}-${count.index + 1}"
  zone         = var.zone
  machine_type = var.machine_type

  allow_stopping_for_update = var.allow_stopping_for_update
  can_ip_forward            = var.can_ip_forward
  #timeouts                  = var.timeouts
  description               = var.description
  deletion_protection       = var.deletion_protection
  min_cpu_platform          = var.min_cpu_platform
  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }

  #scratch_disk {
  #    #interface   = "${var.scratch_disk_interface}"
  #}

  boot_disk {
    auto_delete             = var.boot_disk_auto_delete
    device_name             = var.boot_disk_device_name
    disk_encryption_key_raw = var.disk_encryption_key_raw
    initialize_params {
      size  = var.boot_disk_initialize_params_size
      type  = var.boot_disk_initialize_params_type
      image = var.boot_disk_initialize_params_image
    }
  }

  attached_disk {
    source                  = var.attached_disk_source
    device_name             = var.attached_disk_device_name
    mode                    = var.attached_disk_mode
    disk_encryption_key_raw = var.disk_encryption_key_raw
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    #address            = var.address

    #alias_ip_range {
    #    ip_cidr_range              = "10.138.0.0/20"
    #    subnetwork_range_name      = ""
    #}

    access_config {
      nat_ip                 = var.nat_ip
      public_ptr_domain_name = var.public_ptr_domain_name
      network_tier           = var.network_tier
    }
  }

metadata = {
    enable-oslogin = "TRUE"
    user-data      = <<EOT
#cloud-config
packages: ["ansible"]
write_files:
- path: /etc/ansible/ansible.cfg
  content: |
      [defaults]
      remote_tmp     = /tmp
      local_tmp      = /tmp
runcmd:
- gsutil cp -r ${google_storage_bucket.ansible.url}/ansible /opt
- ansible-playbook /opt/ansible/playbook.yml -t web
EOT
  }
  
  provisioner "local-exec" {
    command = "echo ${self.network_interface.0.access_config.0.nat_ip} >> /home/mehanic/homework/modules/ansible/hosts"
  }

provisioner "local-exec" {
   # command = "echo ${self.network_interface.0.access_config.0.nat_ip} >> private_ips.txt"
    command = "ansible-playbook -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} /home/mehanic/homework/modules/ansible/httpd.yml"
  }
  // labels {
  //   name          = "${lower(var.name)}-ce-${lower(var.environment)}-${count.index + 1}"
  //   environment   = lower(var.environment)
  //   orchestration = lower(var.orchestration)
  // }

  // metadata {
  //   ssh-keys = "${var.ssh_user}:${file("${var.public_key_path}")}"
  //   #shutdown-script = "${file("${path.module}/scripts/shutdown.sh")}"
  // }

   metadata_startup_script = file("${path.module}/${var.install_script_src_path}")
  // #


  #metadata_startup_script = "echo hi > /test.txt"
  #metadata_startup_script = "${file("startup.sh")}"
  #metadata_startup_script = <<SCRIPT
  #    ${file("${path.module}/scripts/install.sh")}
  #SCRIPT

  #provisioner "file" {
  #    source      = "${var.install_script_src_path}"
  #    destination = "${var.install_script_dest_path}"
  #
  #    connection {
  #        type            = "ssh"
  #        user            = "${var.ssh_user}"
  #        port            = "${var.ssh_port}"
  #        private_key     = "${file("${var.private_key_path}")}"
  #        agent           = false
  #        timeout         = "5m"
  #        agent_identity  = false
  #        insecure        = true
  #    }
  #}

  #provisioner "remote-exec" {
  #    connection {
  #        type        = "ssh"
  #        user        = "${var.ssh_user}"
  #        port        = "${var.ssh_port}"
  #        private_key = "${file("${var.private_key_path}")}"
  #        agent       = false
  #        timeout     = "5m"
  #    }
  #
  #    inline = [
  #        "chmod +x ${var.install_script_dest_path}",
  #        "sudo ${var.install_script_dest_path} ${count.index}",
  #    ]
  #}
  #
  #

  tags = [
    "${lower(var.name)}",
    "${lower(var.environment)}",
    "${lower(var.orchestration)}"
  ]

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  scheduling {
    preemptible         = var.scheduling_preemptible
    on_host_maintenance = var.scheduling_on_host_maintenance
    automatic_restart   = var.scheduling_automatic_restart
  }

  #Note: GPU accelerators can only be used with on_host_maintenance option set to TERMINATE.
  guest_accelerator {
    type  = var.guest_accelerator_type
    count = var.guest_accelerator_count
  }

  lifecycle {
    ignore_changes = [
      network_interface,
    ]
    create_before_destroy = true
  }

}
