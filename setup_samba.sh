#!/bin/bash

# This script sets up Samba with a predefined configuration on Ubuntu.

# Update package list and install Samba
echo "Updating package list and installing Samba..."
sudo apt update
sudo apt install -y samba

# Backup the original smb.conf
echo "Backing up the original smb.conf file..."
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

# Write the new configuration to smb.conf
echo "Writing the new Samba configuration..."
sudo bash -c 'cat > /etc/samba/smb.conf <<EOL
#======================= Global Settings =======================

[global]
   unix charset = UTF-8
   workgroup = WORKGROUP
   server string = %h server (Samba, Ubuntu)
   interfaces = 127.0.0.0/8 192.168.80.22/24 192.168.80.30/24
   bind interfaces only = yes
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

#======================= Share Definitions =======================

[printers]
   comment = All Printers
   browseable = no
   path = /var/spool/samba
   printable = yes
   guest ok = no
   read only = yes
   create mask = 0700

[print$]
   comment = Printer Drivers
   path = /var/lib/samba/printers
   browseable = yes
   read only = yes
   guest ok = no

[Share]
   path = /home/shareKG
   writable = yes
   guest ok = yes
   guest only = yes
   force create mode = 0777
   force directory mode = 0777
EOL'

# Create the shared directory and set permissions
echo "Creating the shared directory and setting permissions..."
sudo mkdir -p /home/shareKG
sudo chmod 0777 /home/shareKG

# Restart Samba services
echo "Restarting Samba services..."
sudo systemctl restart smbd nmbd

# Display the status of Samba services
echo "Displaying the status of Samba services..."
sudo systemctl status smbd nmbd

echo "Samba setup completed."

# chmod +x setup_samba.sh

#sudo ./setup_samba.sh
