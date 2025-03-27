# volumes location
\\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes\comfyui_models\_data

# Expose 3375 for remote access
# Turn on Expose daemon on tcp://localhost:2375 without TLS
# forward port on 127.0.0.1 
# note: daemon is running in a container, hence settings in daemon.json on host will affect the daemon running in the container
# see: https://stackoverflow.com/questions/60151451/how-to-expose-2375-from-docker-desktop-for-windows
netsh interface portproxy add v4tov4 listenport=3375 listenaddress=0.0.0.0 connectaddress=127.0.0.1 connectport=2375
netsh interface portproxy add v4tov6 listenport=3375 listenaddress=0.0.0.0 connectaddress=[::1] connectport=2375
# Open port 3375 in Windows Firewall, make sure Edge Traversal is set to "Allow edge traversal"