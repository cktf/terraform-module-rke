#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    apt update
}

uninstall_rke() {
    echo Uninstalling RKE

    if [ "${type}" = "k3s" ]; then
        systemctl stop k3s.service
        systemctl disable k3s.service
        /usr/local/bin/k3s-uninstall.sh
    elif [ "${type}" = "rke2" ]; then
        systemctl stop rke2-server.service
        systemctl disable rke2-server.service
        /usr/local/bin/rke2-uninstall.sh
    fi
}

clear_cache() {
    echo Clearing Cache
    
    rm -Rf /var/lib/apt/lists/*
    rm -Rf /tmp/*
}

uninstall_packages
${try(node.pre_destroy, "")}
uninstall_rke
${try(node.post_destroy, "")}
clear_cache
