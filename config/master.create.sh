#!/bin/sh

install_packages() {
    echo Installing Packages

    apt update
}

install_rke() {
    echo Installing RKE

    export INSTALL_${upper(type)}_NAME="server"
    export INSTALL_${upper(type)}_SKIP_START="true"
    export INSTALL_${upper(type)}_SKIP_ENABLE="true"
    export INSTALL_${upper(type)}_VERSION="${version}"
    export INSTALL_${upper(type)}_CHANNEL="${channel}"

    export ${upper(type)}_TOKEN="${master_token}"
    export ${upper(type)}_AGENT_TOKEN="${worker_token}"
    export INSTALL_${upper(type)}_EXEC="${leader ? "server --cluster-init" : "server --server https://${load_balancer}:6443"}"

    mkdir -p /etc/rancher/${type}
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        kube-apiserver-arg: ["enable-bootstrap-token-auth"]
        disable: [${join(",", [for item in disables : "\"${item}\""])}]
        tls-san: ["${load_balancer}"]
        node-name: "${node.name}"
        node-label: [${join(",", [for item in node.labels : "\"${item}\""])}]
        node-taint: [${join(",", [for item in node.taints : "\"${item}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/registries.yaml > /dev/null
        mirrors:
        %{ for key, value in registries }
            "${key}":
                endpoint:
                    - "${value.endpoint}"
        %{ endfor }
        configs:
        %{ for key, value in registries }
        %{ if value.username != "" && value.password != "" }
            "${replace(value.endpoint, "/https?:\\/\\//", "")}":
                auth:
                    username: ${value.username}
                    password: ${value.password}
        %{ endif }
        %{ endfor }
	EOF

    curl -sfL https://get.${type}.io | sh -
    
    cat <<-EOF | sed -r 's/^ {8}//' | tee /var/lib/rancher/${type}/server/manifests/bootstrap.yaml > /dev/null
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
    cat <<-EOF | sed -r 's/^ {8}//' | tee -a /etc/systemd/system/${type}-server.service.env > /dev/null
        CONTAINERD_HTTPS_PROXY="${https_proxy}"
        CONTAINERD_HTTP_PROXY="${http_proxy}"
        CONTAINERD_NO_PROXY="${no_proxy}"
	EOF

    systemctl enable ${type}-server.service
    systemctl start ${type}-server.service
}

clear_cache() {
    echo Clearing Cache
    
    rm -Rf /var/lib/apt/lists/*
    rm -Rf /tmp/*
}

install_packages
${node.pre_create}
install_rke
${node.post_create}
clear_cache
