#!/bin/bash

SCRIPT_PREFIX="lxd-tomcat"
OS=images:ubuntu/jammy
STORAGE_PATH="/data/lxd/"${SCRIPT_PREFIX}
IP="10.120.11"
IFACE="eth0"
IP_SUBNET=${IP}".1/24"
TOMCAT_POOL=${SCRIPT_PREFIX}"-pool"
SCRIPT_PROFILE_NAME=${SCRIPT_PREFIX}"-profile"
SCRIPT_BRIDGE_NAME=${SCRIPT_PREFIX}"-br"

TOMCAT_NAME=${SCRIPT_PREFIX}"-container"


# check if jq exists
if ! snap list | grep jq >>/dev/null 2>&1; then
  sudo snap install jq 
fi
# check if lxd exists
if ! snap list | grep lxd >>/dev/null 2>&1; then
  sudo snap install lxd 
fi

image_names=("${TOMCAT_NAME}" "${TOMCAT_MINION_NAME}")


if ! [ -d ${STORAGE_PATH} ]; then
    sudo mkdir -p ${STORAGE_PATH}
fi

# creating the pool
lxc storage create ${TOMCAT_POOL} dir source=${STORAGE_PATH}

#create network bridge
lxc network create ${SCRIPT_BRIDGE_NAME} ipv6.address=none ipv4.address=${IP_SUBNET} ipv4.nat=true

# creating needed profile
lxc profile create ${SCRIPT_PROFILE_NAME}

# editing needed profile
echo "config:
devices:
  ${IFACE}:
    name: ${IFACE}
    network: ${SCRIPT_BRIDGE_NAME}
    type: nic
  root:
    path: /
    pool: ${TOMCAT_POOL}
    type: disk
name: ${SCRIPT_PROFILE_NAME}" | lxc profile edit ${SCRIPT_PROFILE_NAME} 

  lxc profile create ${TOMCAT_POOL}-proxy-8080
  lxc profile device add ${TOMCAT_POOL}-proxy-8080 hostport8080 proxy connect="tcp:127.0.0.1:8080" listen="tcp:0.0.0.0:8080"

    #create salt-container container
    lxc init ${OS} ${TOMCAT_NAME} --profile ${SCRIPT_PROFILE_NAME}
    lxc network attach ${SCRIPT_BRIDGE_NAME} ${TOMCAT_NAME} ${IFACE}
    lxc config device set ${TOMCAT_NAME} ${IFACE} ipv4.address ${IP}.2
    lxc start ${TOMCAT_NAME} 
    lxc profile add ${TOMCAT_NAME} ${TOMCAT_POOL}-proxy-8080
    sudo lxc config device add ${TOMCAT_NAME} ${TOMCAT_NAME}-script-share disk source=${PWD}/scripts path=/lxd
    sudo lxc config device add ${TOMCAT_NAME} ${TOMCAT_NAME}-share-share disk source=${PWD}/share path=/tomcat
    sudo lxc exec ${TOMCAT_NAME} -- /bin/bash /lxd/${TOMCAT_NAME}.sh
    
    








