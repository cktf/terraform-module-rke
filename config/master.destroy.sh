#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    apt update
}

uninstall_rke() {
    echo Uninstalling RKE

    systemctl stop ${type}-server.service
    systemctl disable ${type}-server.service
    /usr/local/bin/${type}-uninstall.sh
}

clear_cache() {
    echo Clearing Cache
    
    rm -Rf /var/lib/apt/lists/*
    rm -Rf /tmp/*
}

uninstall_packages
${node.pre_destroy}
uninstall_rke
${node.post_destroy}
clear_cache
