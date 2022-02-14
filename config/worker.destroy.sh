#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    sudo apt update
}

uninstall_rke() {
    echo Uninstalling RKE

    if [ "${type}" = "k3s" ]; then
        sudo systemctl stop k3s-agent.service
        sudo systemctl disable k3s-agent.service
        sudo /usr/local/bin/k3s-uninstall.sh
    elif [ "${type}" = "rke2" ]; then
        sudo systemctl stop rke2-agent.service
        sudo systemctl disable rke2-agent.service
        sudo /usr/local/bin/rke2-uninstall.sh
    fi
}

clear_cache() {
    echo Clearing Cache
    
    sudo rm -Rf /var/lib/apt/lists/*
    sudo rm -Rf /tmp/*
}

uninstall_packages
${node.pre_destroy}
uninstall_rke
${node.post_destroy}
clear_cache
