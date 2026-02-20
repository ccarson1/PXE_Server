# PXE_Server

- cd PXE_Server
- sudo chmod +x setup-pxe-iventoy.sh
- sudo ./setup-pxe-iventoy.sh
- cd /opt/iventoy
- sudo ./iventoy.sh stop
- cd /home/carson/PXE_Server
- sudo chmod +x setup-iventoy-service.sh
- sudo ./setup-iventoy-service.sh


#Move one ISO file

-sudo cp /path/to/your.iso /opt/iventoy/iso/

#Move multiple ISO files

sudo mv /path/to/isos/*.iso /opt/iventoy/iso/
