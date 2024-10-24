**SupraVM** promotes the concept of Contianerized VM to combine the lightweight, portable nature of containers with the strong isolation and full virtualization capabilities of VMs.

## Advantages with Contianerized VM

- **Isolation and Security**. Contianerized VM provides an additional layer of isolation between the host system and the VM, not only reducing the attack surface to the VM from the host system and network, but also limiting the potential impact of vulnerabilities in the VM to the host system. Specific management and control to the VM can also be enforced without making changes to the host system or network.

- **Deployment and Portability**. With all dependencies and configurations encapsulated in a container, Contianerized VM requires minimal setup on the target system, can be easily deployed in the same way regardless of the underlying infrastructure, and is highly portable to run on various platforms once created. Meacwhile, taking advantage of the rich container echosystem, the process of deploying, managing, and scaling Contianerized VMs is much easier and can be automated with significantly reduced time and effort.

## Usage

**SupraVM** takes advantages of the kvm device on host to runs a Containerized VM, loading disk images (.qcow2) files on the host as the system disk and data disks.

```
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
```

### ENV: Image Settings
- **SUPRA_APPS**: set the type of VM to create. MUST set and valid option is *windows* or *linux*. Support to more types such as *macOS* is yet to come.
- **VM_OS_SUB_VER**: Set the OS version of VM for specific handling such as legacy boot. Default is not set and valid option is *windows-xp*, *windows-7* or *windows-2003*.
- **VM_STORAGE_ID**: set the storage id for the VM. MUST set and bind to the host accordingly.

### ENV: VM Specification
- **VM_CPU_CORES**: set the number of cores for the VM. Default is not set to determine the number of cores for the VM based on the number of cores in the host.
- **VM_RAM**: set the amount of memory for the VM, with M for Megabyte and G for Gigabyte. Default is not set to determine the amount of memory for the VM based on the amount of memory in the host.
- **VM_MAC**: set the hardware MAC address of the default NIC in the VM. Default is not set for randomly generated hardware MAC address.

### ENV: Network Control
- **VM_TCP_PORTS**: set to *("TARGET-IP:TARGET-PORT:INCOMING-PORT")* to redirect incoming TCP connections to the *INCOMING-PORT* of the contianer to *TARGET-IP* on *TARGET-PORT* of the VM. Use space/blank to separate multiple redirecting rules, and default is not set for no redirecting rule.
- **VM_GUEST_VNC**: set to *1* to redirect the VGA display over the VNC session on Port *5999*. Default is not set for not redirecting the VGA display over VNC.
- **VM_GUEST_LAN**: set to the local area network for the VM. Default is *10.0.2.0/24*.
- **VM_GUEST_TCP_FWDS**: set to *("TARGET-IP:TARGET-PORT:REAL-IP:REAL-PORT")* to forward TCP connections from the VM to the *TARGET-IP* on *TARGET-PORT* to *REAL-IP* on *REAL-PORT*. Use space/blank to separate multiple forwarding rules, and default is not set for no forwarding rule.
- **VM_GUEST_RESTRICT**: set to *1* to isolate the VM, i.e. it will not be able to contact the host or the outside network. This option does not affect any explicitly set forwarding rules from **VM_GUEST_TCP_FWDS**. Default is not set for not isolating network.

### Mount Volume
- The VM container will load disk images from /opt/vm/{SUPRA_APPS}/{VM_STORAGE_ID}, in which the system disk MUST be named as *sys.qcow2* and data disks MUST be sequentially named as *data[0,1,2,3,4...].qcow2*, starting from *data0.qcow2*.
- The system disk image shall contain all necessary KVM/QEMU guest drivers, please check [Virtio](https://www.linux-kvm.org/page/Virtio) and [virtio-win](https://github.com/virtio-win/kvm-guest-drivers-windows) for detailed information.
*Note*: It is recommanded to take advantage of [quickemu](https://github.com/quickemu-project/quickemu) to generate the system disk, and it is also applicable to convert a VM image in other format, e.g. VMDK from VMware Workstation or VMware Fusion, to get one.


### Host Device
- [KVM](https://www.linux-kvm.org/page/Main_Page) is at the core of running virtual machines with **SupraVM**, please make sure the host is properly configured to enable KVM and the KVM device is directly exposed to the container.

## Credits 
**SupraVM** is inspired and crafted upon the fabulous work from [quickemu](https://github.com/quickemu-project/quickemu).