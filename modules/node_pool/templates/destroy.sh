#!/bin/sh

uninstall_packages() {
    echo Uninstalling Packages

    apt update
}

uninstall_rke() {
    echo Uninstalling RKE

    systemctl stop ${type}-agent.service
    systemctl disable ${type}-agent.service
    /usr/local/bin/${type}-agent-uninstall.sh
}

clear_cache() {
    echo Clearing Cache
    
    rm -Rf /var/lib/apt/lists/*
    rm -Rf /tmp/*
}

uninstall_packages
${pre_destroy_user_data}
uninstall_rke
${post_destroy_user_data}
clear_cache
