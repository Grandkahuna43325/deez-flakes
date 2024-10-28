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
    # bottles

    # Filesystems
    dosfstools
  ];
}

