#!/bin/bash

get_data_disks() {
    directory="$1"
    files=()
    for ((i=0; ;i++)); do
        file="${directory}/data${i}.qcow2"
        if [ -f "$file" ]; then
            files+=("$file")
        else
            break
        fi
    done
    echo "${files[@]}"
}

chown supra:supra /dev/kvm
cd /opt/vm

storage_dir="/opt/vm/linux/${VM_STORAGE_ID}"
data_disk_imgs=($(get_data_disks "${storage_dir}"))

chown -R supra:supra "${storage_dir}"

echo 'guest_os="linux"' > linux.conf
echo "storage_dir=${storage_dir}" >> linux.conf
echo "disk_img=${storage_dir}/sys.qcow2" >> linux.conf
echo "data_disk_imgs=(${data_disk_imgs[@]})" >> linux.conf
echo "os_sub_ver=${VM_OS_SUB_VER}" >> linux.conf

if [[ -v VM_CPU_CORES ]]; then
    echo "cpu_cores=${VM_CPU_CORES}" >> linux.conf
fi

if [[ -v VM_RAM ]]; then
    echo "ram=${VM_RAM}" >> linux.conf
fi

if [[ -v VM_MAC ]]; then
    echo "macaddr=${VM_MAC}" >> linux.conf
fi

if [[ -v VM_GUEST_LAN ]]; then
    echo "guest_lan=${VM_GUEST_LAN}" >> linux.conf
fi

if [[ -v VM_TCP_PORTS ]]; then
    echo "tcp_port_forwards=${VM_TCP_PORTS}" >> linux.conf
fi

if [[ -v VM_UDP_PORTS ]]; then
    echo "udp_port_forwards=${VM_UDP_PORTS}" >> linux.conf
fi

if [[ -v VM_GUEST_VNC ]]; then
    echo "guest_vnc=1" >> linux.conf
fi

if [[ -v VM_GUEST_RESTRICT ]]; then
    echo "guest_restrict=1" >> linux.conf
fi

if [[ -v VM_GUEST_TCP_FWDS ]]; then
    echo "tcp_port_guest_forwards=${VM_GUEST_TCP_FWDS}" >> linux.conf
fi

if [[ -v VM_EXTRA_ISO ]]; then
    echo "extra_iso=${VM_EXTRA_ISO}" >> linux.conf
fi

if [[ -v VM_SYSDISK_IDE ]]; then
    echo "sysdisk_ide=1" >> linux.conf
fi

if [[ -v VM_BOOT_ISO ]]; then
    echo "boot_iso=${VM_BOOT_ISO}" >> linux.conf
fi

cat linux.conf

runuser -u supra -- runvm --vm linux.conf --serial none --public-dir none --monitor none --display none &

wait -n
