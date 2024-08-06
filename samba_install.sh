#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Samba
sudo apt install samba -y

# Backup the original Samba configuration file
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Configure Samba
echo "
[shared]
path = /srv/samba/shared
browseable = yes
read only = no
guest ok = yes
create mask = 0777
directory mask = 0777
" | sudo tee -a /etc/samba/smb.conf

# Create the shared directory
sudo mkdir -p /srv/samba/shared

# Set permissions
sudo chown -R nobody:nogroup /srv/samba/shared
sudo chmod -R 0777 /srv/samba/shared

# Restart Samba service
sudo systemctl restart smbd

# Allow Samba through the firewall (if applicable)
sudo ufw allow 'Samba'

# Output the access information
echo "Samba setup complete. Access the shared folder from another machine using:"
echo "\\\\<IP_ADDRESS>\\shared"
