# ------------------------------------------------------------------------------
# SSH Config Template (used by local-exec in Terraform)
# This script appends an entry to the user's ~/.ssh/config file,
# allowing simplified SSH access to the EC2 instance.
# ------------------------------------------------------------------------------

cat << EOF >> ~/.ssh/config

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}

EOF
