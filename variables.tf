# ------------------------------------------------------------------------------
# host_os: Used to determine the appropriate SSH config command format
# ------------------------------------------------------------------------------
# This variable allows the local-exec provisioner to choose between
# Linux/macOS (bash) and Windows (PowerShell) when executing commands.
# Default is "linux", which works for most non-Windows systems.
# ------------------------------------------------------------------------------
variable "host_os" {
  type    = string
  default = "linux"
}
