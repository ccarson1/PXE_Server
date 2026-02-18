#!/bin/bash

# Path to your local iventoy.service file
SERVICE_SRC="./iventoy.service"
SERVICE_DEST="/etc/systemd/system/iventoy.service"

# Check if the service file exists
if [ ! -f "$SERVICE_SRC" ]; then
    echo "❌ Service file $SERVICE_SRC not found!"
    exit 1
fi

echo "Copying $SERVICE_SRC to $SERVICE_DEST..."
sudo cp "$SERVICE_SRC" "$SERVICE_DEST"

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling iventoy service to start on boot..."
sudo systemctl enable iventoy

echo "Starting iventoy service..."
sudo systemctl start iventoy

echo "✅ iVentoy systemd service is now running!"
echo "Check status with: sudo systemctl status iventoy"
