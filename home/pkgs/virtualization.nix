{configs, pkgs, ...}:

{
  home.packages = with pkgs; [
    vmware-workstation
    libvirt
    virt-manager
    qemu
    uefi-run
    lxc
    swtpm
    docker-compose
    # bottles

    # Filesystems
    dosfstools
  ];
}

