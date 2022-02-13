#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    sudo apt update
}

uninstall_k3s() {
    echo Uninstalling K3S

    sudo systemctl stop k3s.service
    sudo systemctl disable k3s.service
    sudo /usr/local/bin/k3s-uninstall.sh
}

uninstall_rke2() {
    echo Uninstalling RKE2

    sudo systemctl stop rke2-server.service
    sudo systemctl disable rke2-server.service
    sudo /usr/local/bin/rke2-uninstall.sh
}

clear_cache() {
    echo Clearing Cache
    
    sudo rm -Rf /var/lib/apt/lists/*
    sudo rm -Rf /tmp/*
}

uninstall_packages
${node_pre_destroy}
if [ "${cluster_type}" = "k3s" ]; then
    uninstall_k3s
elif [ "${cluster_type}" = "rke2" ]; then
    uninstall_rke2
fi
${node_post_destroy}
clear_cache