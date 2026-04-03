{configs, pkgs, pkgs-unstable, ...}:

{
  home.packages = with pkgs; [
    # pkgs-unstable.vmware-workstation
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

