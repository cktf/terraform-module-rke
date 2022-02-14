#!/bin/sh

install_packages() {
    echo Installing Packages

    sudo apt update
}

install_rke() {
    echo Installing RKE

    export INSTALL_${upper(type)}_VERSION=${version}
    export INSTALL_${upper(type)}_CHANNEL=${channel}

    sudo mkdir -p /etc/rancher/${type}
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/${type}/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        disable: [${join(",", [for item in disables : "\"${item}\""])}]
        server: "${load_balancer}"
        agent-token: "${worker_token}"
        node-name: "${node.name}"
        node-label: [${join(",", [for item in node.labels : "\"${item}\""])}]
        node-taint: [${join(",", [for item in node.taints : "\"${item}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/${type}/registries.yaml > /dev/null
        mirrors:
            docker.io:
                endpoint:
                    - "${registry}"
	EOF

    if [ "${type}" = "k3s" ]; then
        curl -sfL https://get.k3s.io | sudo sh -
        sudo systemctl enable k3s-agent.service
        sudo systemctl start k3s-agent.service
    elif [ "${type}" = "rke2" ]; then
        curl -sfL https://get.rke2.io | sudo sh -
        sudo systemctl enable rke2-agent.service
        sudo systemctl start rke2-agent.service
    fi
}

clear_cache() {
    echo Clearing Cache
    
    sudo rm -Rf /var/lib/apt/lists/*
    sudo rm -Rf /tmp/*
}

install_packages
${try(node.pre_create, "")}
install_rke
${try(node.post_create, "")}
clear_cache
