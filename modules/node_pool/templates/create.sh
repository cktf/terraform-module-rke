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

    export ${upper(type)}_URL="${join_host}"
    export ${upper(type)}_TOKEN="${join_token}"
    export INSTALL_${upper(type)}_EXEC="agent ${join(" ", extra_args)}"

    mkdir -p /etc/rancher/${type}
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
        node-name: "${name}"
        node-label: [${join(",", [for key, val in labels : "\"${key}=${val}\""])}]
        node-taint: [${join(",", [for key, val in taints : "\"${key}=${val}\""])}]
	EOF
    cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/registries.yaml > /dev/null
        mirrors:
        %{ for key, val in registries }
            "${key}":
                endpoint:
                    - "${val.endpoint}"
        %{ endfor }
        configs:
        %{ for key, val in registries }
        %{ if val.username != "" && val.password != "" }
            "${replace(val.endpoint, "/https?:\\/\\//", "")}":
                auth:
                    username: ${val.username}
                    password: ${val.password}
        %{ endif }
        %{ endfor }
	EOF
    
    curl -sfL https://get.${type}.io | sh -

    cat <<-EOF | sed -r 's/^ {8}//' | tee -a /etc/systemd/system/${type}-agent.service.env > /dev/null
        %{ for key, val in extra_envs }
        ${key}="${val}"
        %{ endfor }
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
${pre_create_user_data}
install_rke
${post_create_user_data}
clear_cache
