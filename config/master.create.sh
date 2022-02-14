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
        kube-apiserver-arg: ["enable-bootstrap-token-auth"]
        disable: [${join(",", [for item in disables : "\"${item}\""])}]
        tls-san: ["${load_balancer}"]
        cluster-init: "${leader}"
        server: "${leader ? "" : load_balancer}"
        token: "${master_token}"
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

    sudo mkdir -p /var/lib/rancher/${type}/server/manifests
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /var/lib/rancher/${type}/server/manifests/bootstrap.yaml > /dev/null
        ---
        apiVersion: v1
        kind: Secret
        metadata:
            name: bootstrap-token-${token_id}
            namespace: kube-system
        type: bootstrap.kubernetes.io/token
        stringData:
            description: "bootstrap token"
            token-id: ${token_id}
            token-secret: ${token_secret}
            usage-bootstrap-authentication: "true"
            usage-bootstrap-signing: "true"
            auth-extra-groups: system:bootstrappers:worker,system:bootstrappers:ingress
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
            name: bootstrap-admin
        subjects:
            - kind: Group
              name: system:bootstrappers
              apiGroup: rbac.authorization.k8s.io
        roleRef:
            apiGroup: rbac.authorization.k8s.io
            kind: ClusterRole
            name: cluster-admin    
	EOF

    if [ "${type}" = "k3s" ]; then
        curl -sfL https://get.k3s.io | sudo sh -
        sudo systemctl enable k3s.service
        sudo systemctl start k3s.service
    elif [ "${type}" = "rke2" ]; then
        curl -sfL https://get.rke2.io | sudo sh -
        sudo systemctl enable rke2-server.service
        sudo systemctl start rke2-server.service
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
