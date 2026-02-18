# PXE_Server

 - sudo chmod +x setup-pxe-iventoy.sh
 - sudo ./setup-pxe-iventoy.sh

#After Install

- cd /opt/iventoy
- sudo ./iventoy.sh stop
- sudo ./iventoy.sh start --proxy-dhcp --no-dhcp
- sudo chmod +x setup-iventoy-service.sh
- sudo ./setup-iventoy-service.sh

