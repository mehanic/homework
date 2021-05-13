
terraform {
  required_version = "~> 0.13"
}

provider "google" {
  credentials = file("/home/mehanic/.config/gcloud/creds/concrete-flare-310318-10131f74b587.json")
  project     = "concrete-flare-310318"
  region      = "us-east-1"
}

module "compute_instance" {
  source = "/home/mehanic/homework/modules"
  name   = "TEST"

  project_name = "concrete-flare-310318"

  number_of_instances    = 2
  service_account_scopes = ["userinfo-email", "compute-ro", "storage-ro"]

  enable_attached_disk = false
  attached_disk_source = "test-disk-1"
}

// module "metadata_ssh_keys" {
//   source = "../../modules/metadata_ssh_keys"

//   ssh_users = {
//     root = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUJIx3PkkrnxNAdPALtnUKq3b8+N7Z6Ng0v8UZDHtXCU2IwTpnbh4TjTIGbwgs+J3j6B5qNPIyTZy9TbrcNdkACooylE0biTW7wGTVW+UAVTz2xwrfBypMNeSm9KUQk1xj0tGch5EDgpKfUlMF2gGrRyHmNY3+ExqbfUfzT2V7GEf73iQv2oMawVc39Z+FS6Rkc+OcBlL3xg49eGk55HwFjs3CInfMdAsr5r01bLePxkINoEMRcU7+GdXq1cDXqaB0QNj9qvCdqcO7y2d11O1Azzy7oBrsd1S4BiV4FeaDIZ5WFRAORUjaIOpgkUilFa+TwOfNCtxtbMyN5OXvfsmA7mKsgepZVgUpfgFypOQo8HwMXbj94wJj3Facz83yR5SPRMX/zdVC9qsECv6D0m9Q/r67BFfqN6qYs71ltNc8A0tnMFDzT1Yusa14Qrqhvebrhp4aHAnyrDyyGe1LYDe2hmDxW5fEQbGIAXSFQRa6tXqQ2aJ+ZN4l/uOyeGIgGrc= mehanic@SkyNet>"
//     bar = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDLn..."
//   }
// }

// module "ssh"{
// source = "../../modules/compute-ssh-keys"

// project_name   = "concrete-flare-310318"
//     SSH_PUB_KEYS = [
//         "ansible:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUJIx3PkkrnxNAdPALtnUKq3b8+N7Z6Ng0v8UZDHtXCU2IwTpnbh4TjTIGbwgs+J3j6B5qNPIyTZy9TbrcNdkACooylE0biTW7wGTVW+UAVTz2xwrfBypMNeSm9KUQk1xj0tGch5EDgpKfUlMF2gGrRyHmNY3+ExqbfUfzT2V7GEf73iQv2oMawVc39Z+FS6Rkc+OcBlL3xg49eGk55HwFjs3CInfMdAsr5r01bLePxkINoEMRcU7+GdXq1cDXqaB0QNj9qvCdqcO7y2d11O1Azzy7oBrsd1S4BiV4FeaDIZ5WFRAORUjaIOpgkUilFa+TwOfNCtxtbMyN5OXvfsmA7mKsgepZVgUpfgFypOQo8HwMXbj94wJj3Facz83yR5SPRMX/zdVC9qsECv6D0m9Q/r67BFfqN6qYs71ltNc8A0tnMFDzT1Yusa14Qrqhvebrhp4aHAnyrDyyGe1LYDe2hmDxW5fEQbGIAXSFQRa6tXqQ2aJ+ZN4l/uOyeGIgGrc= mehanic@SkyNet>",
//         "ansible:<your_ssh_public_key_2>"
//     ]
// }