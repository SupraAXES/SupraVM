#!/bin/bash -e

sudo docker run --name supravm-test \
                -d \
                --init \
                -e SUPRA_APPS=windows \
                -e VM_OS_SUB_VER=windows-10 \
                -e VM_STORAGE_ID="win10test" \
                -e VM_CPU_CORES=4 \
                -e VM_RAM=8G \
                -e VM_GUEST_LAN=192.168.199.0/24 \
                -e VM_MAC=00:00:00:01:02:03 \
                -e VM_TCP_PORTS='("0.0.0.0:3389:3389")' \
                -e VM_GUEST_VNC=1 \
                -p 3389:3389 \
                -p 5999:5999 \
                -v /opt/supravm/machine/win10test:/opt/vm/windows/win10test \
                --device /dev/kvm:/dev/kvm \
                supraaxes/supravm