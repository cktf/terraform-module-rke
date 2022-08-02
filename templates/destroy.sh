#!/bin/sh

${pre_destroy_user_data}

systemctl stop ${type}-agent.service
systemctl disable ${type}-agent.service
/usr/local/bin/${type}-agent-uninstall.sh

${post_destroy_user_data}
