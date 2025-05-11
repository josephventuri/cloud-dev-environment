# ------------------------------------------------------------------------------
# outputs.tf
# Provides useful output values after applying the Terraform configuration.
# ------------------------------------------------------------------------------

# The public IP address of the EC2 development instance
output "dev_ip" {
  description = "Public IP address of the EC2 dev node"
  value       = aws_instance.dev_node.public_ip
}
