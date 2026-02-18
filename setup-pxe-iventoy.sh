#!/bin/bash

# =============================
# CONFIGURATION
# =============================
STATIC_IP="192.168.1.50"
NETMASK="24"
GATEWAY="192.168.1.1"
DNS1="192.168.1.1"
DNS2="8.8.8.8"

IVENTOY_INSTALL_DIR="/opt/iventoy"
IVENTOY_DOWNLOAD_URL="https://github.com/ventoy/PXE/releases/latest/download/iventoy-x86_64-linux.tar.gz"
# =============================

set -e

echo "===== PXE + iVentoy Setup Script ====="

# =============================
# STEP 1 - Configure Static IP (Cloud-Init Safe)
# =============================

echo "Disabling cloud-init network management (if present)..."
mkdir -p /etc/cloud/cloud.cfg.d
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg 2>/dev/null || true

echo "Detecting active network interface..."
INTERFACE=$(ip -4 route show default | awk '/default/ {print $5; exit}')

if [ -z "$INTERFACE" ]; then
    echo "❌ Could not detect network interface."
    exit 1
fi

echo "Detected interface: $INTERFACE"

echo "Backing up existing netplan files..."
mkdir -p /etc/netplan/backup
cp /etc/netplan/*.yaml /etc/netplan/backup/ 2>/dev/null || true

# Find existing netplan file
EXISTING_FILE=$(ls /etc/netplan/*.yaml | head -n 1)

if [ -z "$EXISTING_FILE" ]; then
    NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"
else
    NETPLAN_FILE="$EXISTING_FILE"
fi

echo "Modifying netplan file: $NETPLAN_FILE"

cat > $NETPLAN_FILE <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
        - $STATIC_IP/$NETMASK
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses:
          - $DNS1
          - $DNS2
EOF

echo "Testing netplan configuration..."
netplan generate
netplan try || {
    echo "❌ Netplan configuration failed."
    exit 1
}

echo "Applying netplan..."
netplan apply

echo "✅ Static IP configured: $STATIC_IP"


# =============================
# STEP 2 - Install iVentoy
# =============================

echo "Installing required packages..."
apt update
apt install -y wget tar

echo "Creating install directory..."
mkdir -p $IVENTOY_INSTALL_DIR
cd /tmp

echo "Downloading iVentoy..."
wget -O iventoy.tar.gz $IVENTOY_DOWNLOAD_URL

echo "Extracting iVentoy..."
tar -xzf iventoy.tar.gz

echo "Moving iVentoy to $IVENTOY_INSTALL_DIR..."
mv iventoy-*/* $IVENTOY_INSTALL_DIR

chmod +x $IVENTOY_INSTALL_DIR/iventoy.sh

echo "Starting iVentoy..."
cd $IVENTOY_INSTALL_DIR
./iventoy.sh start

echo ""
echo "========================================"
echo "✅ iVentoy Installed and Running!"
echo "Web UI: http://$STATIC_IP:26000"
echo "========================================"
echo ""
echo "Next:"
echo "1) Open the Web UI"
echo "2) Enable Proxy DHCP"
echo "3) Disable built-in DHCP"
echo ""
echo "Done."
