#!/bin/bash

if [ -z "$JENKINS_USER" ]; then
  JENKINS_USER='jenkins'
fi

if [ -z "$JENKINS_PASSWORD" ]; then
  JENKINS_PASSWORD='jenkins'
fi

id "$JENKINS_USER" && exit 0

# Create the user
sudo sysadminctl -addUser "$JENKINS_USER" -fullName "Jenkins" -password "$JENKINS_PASSWORD"
if [ -n "$JENKINS_PICTURE" ]; then
  JENKINS_PICTURE_BASENAME=$(basename "$JENKINS_PICTURE")
  sudo mv "$JENKINS_PICTURE" "/Library/User Pictures/$JENKINS_PICTURE_BASENAME"
  sudo dscl . delete /Users/$JENKINS_USER jpegphoto
  sudo dscl . delete /Users/$JENKINS_USER Picture
  sudo dscl . create /Users/$JENKINS_USER Picture "/Library/User Pictures/$JENKINS_PICTURE_BASENAME"
fi

# Grant remote access permission
sudo dscl . append /Groups/com.apple.access_ssh user "$JENKINS_USER"
sudo dscl . append /Groups/com.apple.access_ssh groupmembers `dscl . read "/Users/$JENKINS_USER" GeneratedUID | cut -d " " -f 2`

# Add the public key used by the CI master to the `.ssh/authorized_keys` file
sudo mkdir "/Users/$JENKINS_USER/.ssh"
sudo echo "$JENKINS_PUBLIC_KEY" > "/Users/$JENKINS_USER/.ssh/authorized_keys"
sudo chown -R "$JENKINS_USER" "/Users/$JENKINS_USER/.ssh"

# Disable screen saver
sudo -u "$JENKINS_USER" defaults -currentHost write com.apple.screensaver idleTime 0

# Some basic SSH config
echo 'Host *' | sudo -u "$JENKINS_USER" tee "/Users/$JENKINS_USER/.ssh/config"
echo '    StrictHostKeyChecking=no' | sudo -u "$JENKINS_USER" tee -a "/Users/$JENKINS_USER/.ssh/config"
echo '    UserKnownHostsFile=/dev/null' | sudo -u "$JENKINS_USER" tee -a "/Users/$JENKINS_USER/.ssh/config"
