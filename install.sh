#!/bin/bash

# Variables
APP_NAME="get-server-info"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/$APP_NAME.service"
EXECUTABLE_URL="https://raw.githubusercontent.com/cameronjweeks/get_server_info/main/dist/app"
EXECUTABLE="$INSTALL_DIR/$APP_NAME"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Download the executable from GitHub
echo "Downloading $APP_NAME from GitHub..."
curl -fsSL -o "$EXECUTABLE" "$EXECUTABLE_URL"
if [[ $? -ne 0 ]]; then
    echo "Failed to download the executable. Please check the URL."
    exit 1
fi

# Make the executable file executable
chmod +x "$EXECUTABLE"

# Create a systemd service file
echo "Creating systemd service..."
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Get Server Info
After=network.target

[Service]
ExecStart=$EXECUTABLE
Restart=always
User=root
WorkingDirectory=$INSTALL_DIR

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
echo "Enabling and starting $APP_NAME service..."
systemctl daemon-reload
systemctl enable $APP_NAME
systemctl start $APP_NAME

# Check service status
systemctl status $APP_NAME

echo "Installation completed successfully."