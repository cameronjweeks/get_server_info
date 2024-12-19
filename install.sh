#!/bin/bash

# Variables
APP_NAME="get-server-info"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/$APP_NAME.service"
EXECUTABLE="./dist/app"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if the executable exists
if [[ ! -f "$EXECUTABLE" ]]; then
    echo "Executable not found at $EXECUTABLE. Run PyInstaller first."
    exit 1
fi

# Copy the executable to the install directory
echo "Installing $APP_NAME to $INSTALL_DIR..."
cp "$EXECUTABLE" "$INSTALL_DIR/$APP_NAME"
chmod +x "$INSTALL_DIR/$APP_NAME"

# Create a systemd service file
echo "Creating systemd service..."
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Get Server Info
After=network.target

[Service]
ExecStart=$INSTALL_DIR/$APP_NAME
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