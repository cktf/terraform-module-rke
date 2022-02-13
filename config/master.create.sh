#!/bin/sh

install_packages() {
    echo Installing Packages

    sudo apt update
}

install_k3s() {
    echo Installing K3S

    export INSTALL_K3S_VERSION=${cluster_version}
    export INSTALL_K3S_CHANNEL=${cluster_channel}

    sudo mkdir -p /etc/rancher/k3s
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /etc/rancher/k3s/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        kube-apiserver-arg: ["enable-bootstrap-token-auth"]
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

    sudo mkdir -p /var/lib/rancher/k3s/server/manifests
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /var/lib/rancher/k3s/server/manifests/bootstrap.yaml > /dev/null
        ---
        apiVersion: v1
        kind: Secret
        metadata:
            name: bootstrap-token-${cluster_token_id}
            namespace: kube-system
        type: bootstrap.kubernetes.io/token
        stringData:
            description: "bootstrap token"
            token-id: ${cluster_token_id}
            token-secret: ${cluster_token_secret}
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
        kube-apiserver-arg: ["enable-bootstrap-token-auth"]
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

    sudo mkdir -p /var/lib/rancher/rke2/server/manifests
    cat <<-EOF | sed -r 's/^ {8}//' | sudo tee /var/lib/rancher/rke2/server/manifests/bootstrap.yaml > /dev/null
        ---
        apiVersion: v1
        kind: Secret
        metadata:
            name: bootstrap-token-${cluster_token_id}
            namespace: kube-system
        type: bootstrap.kubernetes.io/token
        stringData:
            description: "bootstrap token"
            token-id: ${cluster_token_id}
            token-secret: ${cluster_token_secret}
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
${node_pre_create}
if [ "${cluster_type}" = "k3s" ]; then
    install_k3s
elif [ "${cluster_type}" = "rke2" ]; then
    install_rke2
fi
${node_post_create}
clear_cache