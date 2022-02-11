#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    sudo apt update
    sudo sed -i 's/DNS=178.22.122.100 185.51.200.2/#DNS=/' /etc/systemd/resolved.conf
    sudo service systemd-resolved restart
}

uninstall_k3s() {
    echo Uninstalling K3S

    sudo systemctl stop k3s-agent.service
    sudo systemctl disable k3s-agent.service
    sudo /usr/local/bin/k3s-uninstall.sh
}

uninstall_rke2() {
    echo Uninstalling RKE2

    sudo systemctl stop rke2-agent.service
    sudo systemctl disable rke2-agent.service
    sudo /usr/local/bin/rke2-uninstall.sh
}

clear_cache() {
    echo Clearing Cache
    
    sudo rm -Rf /var/lib/apt/lists/*
    sudo rm -Rf /tmp/*
}

uninstall_packages
uninstall_k3s
clear_cache