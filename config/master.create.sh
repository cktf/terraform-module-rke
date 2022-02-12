#!/bin/sh

install_packages() {
    echo Installing Packages

    sudo apt update
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
    sudo sed -i 's/#DNS=/DNS=178.22.122.100 185.51.200.2/' /etc/systemd/resolved.conf
    sudo service systemd-resolved restart
}

install_k3s() {
    echo Installing K3S

    export INSTALL_K3S_VERSION=${cluster_version}
    export INSTALL_K3S_CHANNEL=${cluster_channel}

    sudo mkdir -p /etc/rancher/k3s
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/k3s/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        disable: [${join(",", [for item in cluster_disables : "\"${item}\""])}]
        tls-san: ["${cluster_load_balancer}"]
        cluster-init: "${cluster_leader}"
        server: "${cluster_leader ? "" : cluster_load_balancer}"
        token: "${cluster_master_token}"
        agent-token: "${cluster_worker_token}"
        node-name: "${node_name}"
        node-label: [${join(",", [for item in node_labels : "\"${item}\""])}]
        node-taint: [${join(",", [for item in node_taints : "\"${item}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/k3s/registries.yaml > /dev/null
        mirrors:
            docker.io:
                endpoint:
                    - "${cluster_registry}"
	EOF

    curl -sfL https://get.k3s.io | sudo sh -
    sudo systemctl enable k3s.service
    sudo systemctl start k3s.service
}

install_rke2() {
    echo Installing RKE2

    export INSTALL_RKE2_VERSION=${cluster_version}
    export INSTALL_RKE2_CHANNEL=${cluster_channel}

    sudo mkdir -p /etc/rancher/rke2
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/rke2/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        disable: [${join(",", [for item in cluster_disables : "\"${item}\""])}]
        tls-san: ["${cluster_load_balancer}"]
        cluster-init: "${cluster_leader}"
        server: "${cluster_leader ? "" : cluster_load_balancer}"
        token: "${cluster_master_token}"
        agent-token: "${cluster_worker_token}"
        node-name: "${node_name}"
        node-label: [${join(",", [for item in node_labels : "\"${item}\""])}]
        node-taint: [${join(",", [for item in node_taints : "\"${item}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/rke2/registries.yaml > /dev/null
        mirrors:
            docker.io:
                endpoint:
                    - "${cluster_registry}"
	EOF
    
    curl -sfL https://get.rke2.io | sudo sh -
    sudo systemctl enable rke2-server.service
    sudo systemctl start rke2-server.service
}

clear_cache() {
    echo Clearing Cache
    
    sudo rm -Rf /var/lib/apt/lists/*
    sudo rm -Rf /tmp/*
}

install_packages
if [ "${cluster_type}" = "k3s" ]; then
    install_k3s
elif [ "${cluster_type}" = "rke2" ]; then
    install_rke2
fi
clear_cache