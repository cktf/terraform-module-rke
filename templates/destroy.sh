#!/bin/sh

${pre_destroy_user_data}

systemctl stop ${type}-${name}.service
systemctl disable ${type}-${name}.service
/usr/local/bin/${type}-${name}-uninstall.sh

${post_destroy_user_data}
