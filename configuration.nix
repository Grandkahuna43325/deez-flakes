# Edit this configuration file to define what should be installed on
#gutenprint hplip splix  your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, pkgsUnstable, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${pkgsUnstable.path}/nixos/modules/programs/obs-studio.nix")
    ];

  nixpkgs.overlays = [
    (
      final: prev:
        let
          finalAttrs = final.vmware-workstation;
          version = "17.6.1";
          build = "24319023";
          baseUrl = "https://web.archive.org/web/20241105192443if_/https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${version}/${build}/linux";
          vmware-unpack-env = prev.buildFHSEnv {
            pname = "vmware-unpack-env";
            inherit version;
            targetPkgs = pkgs: [ pkgs.zlib ];
          };
        in
        {
          vmware-workstation = prev.vmware-workstation.overrideAttrs {
            src =
              prev.fetchzip
                {
                  url = "${baseUrl}/core/VMware-Workstation-${version}-${build}.x86_64.bundle.tar";
                  hash = "sha256-VzfiIawBDz0f1w3eynivW41Pn4SqvYf/8o9q14hln4s=";
                  stripRoot = false;
                }
              + "/VMware-Workstation-${version}-${build}.x86_64.bundle";
            unpackPhase = ''
              ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${finalAttrs.src} --extract unpacked"
            '';
          };
        }
    )
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     obs-studio = pkgsUnstable.obs-studio;
  #   })
  # ];

  systemd.services.wakeonlan = {
    description = "Reenable wake on lan every boot";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      RemainAfterExit = "true";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp4s0 wol g";
    };
    wantedBy = [ "default.target" ];
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      # obs-ndi
      obs-teleport
      droidcam-obs
      wlrobs
    ];
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    ddcci-driver
    xone
    xpadneo
    (callPackage ./pkgs/xpad.nix { })
    nvidia_x11
  ];
  services.udev.extraRules = ''
    # Steam Controller udev rules
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", GROUP="input", MODE="0660"
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    # Steam Controller over bluetooth
    KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0660", GROUP="input"

    ACTION=="add", \
    	ATTRS{idVendor}=="2dc8", \
    	ATTRS{idProduct}=="3106", \
    	RUN+="${pkgs.kmod}/bin/modprobe xpad", \
    	RUN+="${pkgs.bash}/bin/sh -c 'echo 2dc8 3106 > /sys/bus/usb/drivers/xpad/new_id'"
  '';

  boot = {
    kernelModules = [
      "v4l2loopback"
      "i2c-dev"
      "xpad"
      "hid-nintendo"
      "xone"
      "xpadneo"
    ];
    # extraModulePackages = [
    #   config.boot.kernelPackages.ddcci-driver
    #     config.boot.kernelPackages.xone
    #     config.boot.kernelPackages.xpadneo
    #     (config.boot.kernelPackages.callPackage ./packages/xpad.nix { })
    #     config.boot.kernelPackages.v4l2loopback
    #     config.boot.kernelPackages.nvidia_x11
    # ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="My OBS Virt Cam" exclusive_caps=1
    '';


  };
  security.polkit.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the X11 windowing system (as fallback).
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ samsung-unified-linux-driver ];


  # samsung/ml2165.ppd Samsung ML-2165, 2.0.0
  # samsung/ml2165fr.ppd Samsung TRANSLATE ML-2165, 2.0.0
  # samsung/ml2165pt.ppd Samsung TRANSLATE ML-2165, 2.0.0

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  };

  # Enable XDG Desktop Portal and required backends
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      xdg-desktop-portal
    ];
  };

  users.extraUsers.grandkahuna43325.extraGroups = [ "audio" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.grandkahuna43325 = {
    isNormalUser = true;
    description = "Grandkahuna43325";
    extraGroups = [ "networkmanager" "wheel" "input" "uinput" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    steam-run
    steamcontroller
    pkgsUnstable.neovim
    # pkgsUnstable.vmware-workstation
    git
    wget
    alacritty
    unzip
    steam
    protontricks
    protonup-qt
    lutris
    wine
    wineWowPackages.waylandFull
    winetricks
    # conroller sc-controller
    pinentry-curses
    kdePackages.xwaylandvideobridge
    weylus
    wireguard-tools
    ntfs3g

    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly

  ];

  programs = {
    steam = {
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Required for Steam Controller
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  # hardware.xone.enable = true;

  # something something gnupg
  services.pcscd.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 31536000;
      max-cache-ttl = 31536000;
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true; # or use keys


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
      8080
      3000
      #Tauri mobile apps
      1420
    ];
    allowedUDPPorts = [
      #Tauri mobile apps
      1420
      #OBS-teleport
      9999
      8081
      # Wireguard
      51820
    ];
  };

  # Wireguard configuration
  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = [ "10.0.0.2/24" ];
  #     privateKey = "/home/grandkahuna43325/wireguard-keys/private";  # Replace with your actual private key
  #
  #     peers = [
  #       {
  #         publicKey = "/home/grandkahuna43325/wireguard-keys/server-public";  # Replace with actual server public key
  #         allowedIPs = [ "10.0.0.1/32" ];
  #         endpoint = "192.168.88.67:51820";  # Replace with actual server IP/hostname
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?


  # __________________________


  nix.settings.trusted-users = [
    "root"
    "grandkahuna43325"
  ];


  #NVIDIA
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "vmware" ];
  virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "535.154.05";
    #   sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
    #   sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
    #   openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
    #   settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
    #   persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
    # };
  };

  # systemd.services."xwaylandvideobridge" = {
  #   description = "XWayland Video Bridge Service";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.xwaylandvideobridge}/bin/xwaylandvideobridge";
  #     user = "grandkahuna43325";
  #   };
  # };

  environment.pathsToLink = [ "/libexec" ];

  # i3
  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };

    # displayManager = {
    #   defaultSession = "none+i3";
    # };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        picom
        polybar
        rofi
      ];
    };
  };

  #hyprland
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.variables.EDITOR = "nvim";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;

  programs.weylus = {
    enable = true;
    users = [ "grandkahuna43325" ];
    openFirewall = true;
  };
}


# # Edit this configuration file to define what should be installed on
# #gutenprint hplip splix  your system.  Help is available in the configuration.nix(5) man page
# # and in the NixOS manual (accessible by running ‘nixos-help’).
#
# { config, inputs, pkgs, pkgsUnstable, ... }:
#
# {
#   imports =
#     [
#       # Include the results of the hardware scan.
#       ./hardware-configuration.nix
#       # (import "${pkgsUnstable.path}/nixos/modules/programs/obs-studio.nix")
#     ];
#
#   # nixpkgs.overlays = [
#   #   (final: prev: {
#   #     obs-studio = pkgsUnstable.obs-studio;
#   #   })
#   # ];
#
#   systemd.services.wakeonlan = {
#     description = "Reenable wake on lan every boot";
#     after = [ "network.target" ];
#     serviceConfig = {
#       Type = "simple";
#       RemainAfterExit = "true";
#       ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp4s0 wol g";
#     };
#     wantedBy = [ "default.target" ];
#   };
#
#   programs.obs-studio = {
#     enable = true;
#     enableVirtualCamera = true;
#     plugins = with pkgs.obs-studio-plugins; [
#       obs-backgroundremoval
#       obs-pipewire-audio-capture
#       # obs-ndi
#       obs-teleport
#       droidcam-obs
#       wlrobs
#     ];
#   };
#
#   boot.extraModulePackages = with config.boot.kernelPackages; [
#     v4l2loopback
#     ddcci-driver
#     xone
#     xpadneo
#     (callPackage ./pkgs/xpad.nix { })
#     nvidia_x11
#   ];
#   services.udev.extraRules = ''
#     ACTION=="add", \
#     	ATTRS{idVendor}=="2dc8", \
#     	ATTRS{idProduct}=="3106", \
#     	RUN+="${pkgs.kmod}/bin/modprobe xpad", \
#     	RUN+="${pkgs.bash}/bin/sh -c 'echo 2dc8 3106 > /sys/bus/usb/drivers/xpad/new_id'"
#   '';
#
#   boot = {
#     kernelModules = [
#       "v4l2loopback"
#       "i2c-dev"
#       "xpad"
#       "hid-nintendo"
#       "xone"
#       "xpadneo"
#     ];
#     # extraModulePackages = [
#     #   config.boot.kernelPackages.ddcci-driver
#     #     config.boot.kernelPackages.xone
#     #     config.boot.kernelPackages.xpadneo
#     #     (config.boot.kernelPackages.callPackage ./packages/xpad.nix { })
#     #     config.boot.kernelPackages.v4l2loopback
#     #     config.boot.kernelPackages.nvidia_x11
#     # ];
#     extraModprobeConfig = ''
#       options v4l2loopback devices=1 video_nr=1 card_label="My OBS Virt Cam" exclusive_caps=1
#     '';
#
#
#   };
#   security.polkit.enable = true;
#
#   # Bootloader.
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.efi.canTouchEfiVariables = true;
#
#   networking.hostName = "nixos"; # Define your hostname.
#   # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
#
#   # Configure network proxy if necessary
#   # networking.proxy.default = "http://user:password@proxy:port/";
#   # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#
#   # Enable networking
#   networking.networkmanager.enable = true;
#
#   # Set your time zone.
#   time.timeZone = "Europe/Warsaw";
#
#   # Select internationalisation properties.
#   i18n.defaultLocale = "en_US.UTF-8";
#
#   i18n.extraLocaleSettings = {
#     LC_ADDRESS = "pl_PL.UTF-8";
#     LC_IDENTIFICATION = "pl_PL.UTF-8";
#     LC_MEASUREMENT = "pl_PL.UTF-8";
#     LC_MONETARY = "pl_PL.UTF-8";
#     LC_NAME = "pl_PL.UTF-8";
#     LC_NUMERIC = "pl_PL.UTF-8";
#     LC_PAPER = "pl_PL.UTF-8";
#     LC_TELEPHONE = "pl_PL.UTF-8";
#     LC_TIME = "pl_PL.UTF-8";
#   };
#
#   # Enable the X11 windowing system (as fallback).
#   services.xserver.enable = true;
#
#   # Enable the KDE Plasma Desktop Environment.
#   services.displayManager.sddm = {
#     enable = true;
#     wayland.enable = true;
#   };
#   services.desktopManager.plasma6.enable = true;
#
#   # Configure keymap in X11
#   services.xserver.xkb = {
#     layout = "pl";
#     variant = "";
#   };
#
#   # Configure console keymap
#   console.keyMap = "pl2";
#
#   # Enable CUPS to print documents.
#   services.printing.enable = true;
#   services.printing.drivers = with pkgs; [ samsung-unified-linux-driver ];
#
#
#   # samsung/ml2165.ppd Samsung ML-2165, 2.0.0
#   # samsung/ml2165fr.ppd Samsung TRANSLATE ML-2165, 2.0.0
#   # samsung/ml2165pt.ppd Samsung TRANSLATE ML-2165, 2.0.0
#
#   # Enable sound with pipewire.
#   hardware.pulseaudio.enable = false;
#   security.rtkit.enable = true;
#
#   services.pipewire = {
#     enable = true;
#     alsa.enable = true;
#     alsa.support32Bit = true;
#     pulse.enable = true;
#     wireplumber.enable = true;
#     # If you want to use JACK applications, uncomment this
#     jack.enable = true;
#   };
#
#   # Enable XDG Desktop Portal and required backends
#   xdg.portal = {
#     enable = true;
#     extraPortals = with pkgs; [
#       xdg-desktop-portal-kde
#       xdg-desktop-portal-gtk
#       xdg-desktop-portal-hyprland
#       xdg-desktop-portal
#     ];
#   };
#
#   users.extraUsers.grandkahuna43325.extraGroups = [ "audio" ];
#
#   # Enable touchpad support (enabled default in most desktopManager).
#   # services.xserver.libinput.enable = true;
#
#   # Define a user account. Don't forget to set a password with ‘passwd’.
#   users.users.grandkahuna43325 = {
#     isNormalUser = true;
#     description = "Grandkahuna43325";
#     extraGroups = [ "networkmanager" "wheel" ];
#     packages = with pkgs; [
#       kdePackages.kate
#       #  thunderbird
#     ];
#   };
#
#   # Install firefox.
#   programs.firefox.enable = true;
#
#   # Allow unfree packages
#   nixpkgs.config.allowUnfree = true;
#
#   environment.systemPackages = with pkgs; [
#     pkgsUnstable.neovim
#     git
#     wget
#     alacritty
#     unzip
#     steam
#     lutris
#     wine
#     wineWowPackages.waylandFull
#     winetricks
#     # conroller sc-controller
#     pinentry-curses
#     xwaylandvideobridge
#     wireguard-tools
#   ];
#
#   programs = {
#     steam = {
#       enable = true;
#       extest.enable = true;
#       gamescopeSession.enable = true;
#       remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#       dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
#       localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
#     };
#
#     gamescope = {
#       enable = true;
#       capSysNice = true;
#     };
#   };
#
#   # hardware.xone.enable = true;
#
#   # something something gnupg
#   services.pcscd.enable = true;
#   services.dbus.packages = [ pkgs.gcr ];
#   programs.gnupg.agent = {
#     enable = true;
#     pinentryPackage = pkgs.pinentry-curses;
#     enableSSHSupport = true;
#   };
#
#
#   # Some programs need SUID wrappers, can be configured further or are
#   # started in user sessions.
#   # programs.mtr.enable = true;
#   # programs.gnupg.agent = {
#   #   enable = true;
#   #   enableSSHSupport = true;
#   # };
#
#   # List services that you want to enable:
#
#   # Enable the OpenSSH daemon.
#   # services.openssh.enable = true;
#
#   # Open ports in the firewall.
#   # networking.firewall.allowedTCPPorts = [ ... ];
#   # networking.firewall.allowedUDPPorts = [ ... ];
#   # Or disable the firewall altogether.
#   networking.firewall = {
#     enable = true;
#     allowedTCPPorts = [
#       22
#       80
#       443
#       8080
#       3000
#       #Tauri mobile apps
#       1420
#     ];
#     allowedUDPPorts = [
#       #Tauri mobile apps
#       1420
#       #OBS-teleport
#       9999
#       8081
#       # Wireguard
#       51820
#     ];
#   };
#
#   # Wireguard configuration
#   # networking.wg-quick.interfaces = {
#   #   wg0 = {
#   #     address = [ "10.0.0.2/24" ];
#   #     privateKey = "/home/grandkahuna43325/wireguard-keys/private";  # Replace with your actual private key
#   #
#   #     peers = [
#   #       {
#   #         publicKey = "/home/grandkahuna43325/wireguard-keys/server-public";  # Replace with actual server public key
#   #         allowedIPs = [ "10.0.0.1/32" ];
#   #         endpoint = "192.168.88.67:51820";  # Replace with actual server IP/hostname
#   #         persistentKeepalive = 25;
#   #       }
#   #     ];
#   #   };
#   # };
#
#   # This value determines the NixOS release from which the default
#   # settings for stateful data, like file locations and database versions
#   # on your system were taken. It‘s perfectly fine and recommended to leave
#   # this value at the release version of the first install of this system.
#   # Before changing this value read the documentation for this option
#   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
#   system.stateVersion = "24.11"; # Did you read the comment?
#
#
#   # __________________________
#
#
#   nix.settings.trusted-users = [
#     "root"
#     "grandkahuna43325"
#   ];
#
#
#   #NVIDIA
#   # Enable OpenGL
#   hardware.opengl = {
#     enable = true;
#   };
#
#   # Load nvidia driver for Xorg and Wayland
#   services.xserver.videoDrivers = [ "nvidia" "vmware" ];
#   virtualisation.vmware.host.enable = true;
#
#   hardware.nvidia = {
#
#     # Modesetting is required.
#     modesetting.enable = true;
#
#     # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
#     # Enable this if you have graphical corruption issues or application crashes after waking
#     # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
#     # of just the bare essentials.
#     powerManagement.enable = false;
#
#     # Fine-grained power management. Turns off GPU when not in use.
#     # Experimental and only works on modern Nvidia GPUs (Turing or newer).
#     powerManagement.finegrained = false;
#
#     # Use the NVidia open source kernel module (not to be confused with the
#     # independent third-party "nouveau" open source driver).
#     # Support is limited to the Turing and later architectures. Full list of
#     # supported GPUs is at:
#     # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
#     # Only available from driver 515.43.04+
#     # Currently alpha-quality/buggy, so false is currently the recommended setting.
#     open = false;
#
#     # Enable the Nvidia settings menu,
#     # accessible via `nvidia-settings`.
#     nvidiaSettings = true;
#
#     # Optionally, you may need to select the appropriate driver version for your specific GPU.
#     package = config.boot.kernelPackages.nvidiaPackages.stable;
#     # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#     #   version = "535.154.05";
#     #   sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
#     #   sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
#     #   openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
#     #   settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
#     #   persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
#     # };
#   };
#
#   systemd.services."xwaylandvideobridge" = {
#     description = "XWayland Video Bridge Service";
#     wantedBy = [ "multi-user.target" ];
#     serviceConfig = {
#       ExecStart = "${pkgs.xwaylandvideobridge}/bin/xwaylandvideobridge";
#       user = "grandkahuna43325";
#     };
#   };
#
#
#   programs.hyprland = {
#     # Install the packages from nixpkgs
#     enable = true;
#     # Whether to enable XWayland
#     xwayland.enable = true;
#   };
#
#   programs.zsh.enable = true;
#   users.defaultUserShell = pkgs.zsh;
#   environment.variables.EDITOR = "nvim";
#   nix.settings.experimental-features = [ "nix-command" "flakes" ];
#   programs.nix-ld.enable = true;
# }
