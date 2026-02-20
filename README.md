# PXE_Server

- cd PXE_Server
- sudo chmod +x setup-pxe-iventoy.sh
- sudo ./setup-pxe-iventoy.sh
- cd /opt/iventoy
- sudo ./iventoy.sh stop
- cd /home/[user]/PXE_Server
- sudo chmod +x setup-iventoy-service.sh
- sudo ./setup-iventoy-service.sh


#Move one ISO file

- sudo cp /path/to/your.iso /opt/iventoy/iso/

#Move multiple ISO files

- sudo mv /path/to/isos/*.iso /opt/iventoy/iso/

#Create a reservation in OPNsense for the PXE_Server IP
- Dnsmasq DNS & DHCP > Leases
- Press the + icon next to the lease that has the matching MAC address aas the PXE_Server
- Create the reservation with the IP address you wish to put the PXE_Server on
- Save and Apply the changes

#Start the iVentoy server
- When the iVentoy service is running on the linux server, open a browser window on a computer on the same network
- Type in the ip address of the pxe server and the port iVentoy is running on [http://192.168.1.50:26000/]
