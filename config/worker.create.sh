#!/bin/sh

install_packages() {
    echo Installing Packages

    apt update
}

install_rke() {
    echo Installing RKE

    export INSTALL_${upper(type)}_NAME="agent"
    export INSTALL_${upper(type)}_SKIP_START="true"
    export INSTALL_${upper(type)}_SKIP_ENABLE="true"
    export INSTALL_${upper(type)}_VERSION="${version}"
    export INSTALL_${upper(type)}_CHANNEL="${channel}"

    export ${upper(type)}_TOKEN="${worker_token}"
    export ${upper(type)}_URL="https://${load_balancer}:6443"

    mkdir -p /etc/rancher/${type}
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
        write-kubeconfig-mode: "0644"
        disable: [${join(",", [for item in disables : "\"${item}\""])}]
        node-name: "${node.name}"
        node-label: [${join(",", [for item in node.labels : "\"${item}\""])}]
        node-taint: [${join(",", [for item in node.taints : "\"${item}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/registries.yaml > /dev/null
        mirrors:
        %{ for key, value in registries }
            "${key}":
                endpoint:
                    - "https://${value.endpoint}"
        %{ endfor }
        configs:
        %{ for key, value in registries }
        %{ if can(value.username) && can(value.password) }
            "${value.endpoint}":
                auth:
                    username: ${value.username}
                    password: ${value.password}
        %{ endif }
        %{ endfor }
	EOF
    
    curl -sfL https://get.${type}.io | sh -

    cat <<-EOF | sed -r 's/^ {8}//' | tee -a /etc/systemd/system/${type}-agent.service.env > /dev/null
        CONTAINERD_HTTPS_PROXY="${https_proxy}"
        CONTAINERD_HTTP_PROXY="${http_proxy}"
        CONTAINERD_NO_PROXY="${no_proxy}"
	EOF

    systemctl enable ${type}-agent.service
    systemctl start ${type}-agent.service
}

clear_cache() {
    echo Clearing Cache
    
    rm -Rf /var/lib/apt/lists/*
    rm -Rf /tmp/*
}

install_packages
${try(node.pre_create, "")}
install_rke
${try(node.post_create, "")}
clear_cache
