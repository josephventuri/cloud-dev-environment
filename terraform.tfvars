# ------------------------------------------------------------------------------
# terraform.tfvars
# This file supplies actual values for the input variables defined in variables.tf.
# It’s automatically loaded by Terraform when you run plan/apply.
# ------------------------------------------------------------------------------

# Specifies the host operating system for the local-exec provisioner.
# Used to select the correct interpreter: "bash" for Linux/macOS, "Powershell" for Windows.
host_os = "linux"
