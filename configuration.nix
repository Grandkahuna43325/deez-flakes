# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.overlays = with inputs; [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
    (final: prev: {
      zjstatus = zjstatus.packages.${prev.system}.default;
    })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [
      "root"
      "grandkahuna43325"
    ];
  };


  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
      ddcci-driver
      xone
      #xpadneo
      #(callPackage ./home/pkgs/xpad.nix { })
      nvidia_x11
    ];

    kernelModules = [
      "v4l2loopback"
      "i2c-dev"
      #"xpad"
      #"hid-nintendo"
      #"xone"
      #"xpadneo"
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
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  systemd = {
    services = {
      # faster boot time
      NetworkManager-wait-online.enable = false;
      wakeonlan = {
        description = "Reenable wake on lan every boot";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          RemainAfterExit = "true";
          ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp4s0 wol g";
        };
        wantedBy = [ "default.target" ];
      };
    };

  };




  services.udev.extraRules = ''
    # Your Xbox-style controller rule (not related to Steam Controller)
    ACTION=="add", \
      ATTRS{idVendor}=="2dc8", \
      ATTRS{idProduct}=="3106", \
      RUN+="${pkgs.kmod}/bin/modprobe xpad", \
      RUN+="${pkgs.bash}/bin/sh -c 'echo 2dc8 3106 > /sys/bus/usb/drivers/xpad/new_id'"
  '';

  networking = {
    hostName = "grandkahuna43325";
    networkmanager.enable = true;
    search = [ "local" ];
    nameservers = [ "192.168.88.8" "192.168.88.1" ];
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # kde connect
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # kde connect
      ];
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

        9
      ];
    };
    interfaces = {
      enp4s0 = {
        wakeOnLan.enable = true;
      };
    };
  };


  # Enable the KDE Plasma Desktop Environment.
  # Configure console keymap
  console.keyMap = "pl2";


  # samsung/ml2165.ppd Samsung ML-2165, 2.0.0
  # samsung/ml2165fr.ppd Samsung TRANSLATE ML-2165, 2.0.0
  # samsung/ml2165pt.ppd Samsung TRANSLATE ML-2165, 2.0.0


  users = {
    defaultUserShell = pkgs.zsh;

    extraUsers.grandkahuna43325.extraGroups = [ "audio" ];

    users.grandkahuna43325 = {
      isNormalUser = true;
      description = "Grandkahuna43325";
      extraGroups = [ "networkmanager" "wheel" "input" "uinput" "docker" ];
      packages = with pkgs; [
        kdePackages.kate
        #  thunderbird
      ];
    };
  };


  # hardware.xone.enable = true;
  programs = {
    kdeconnect.enable = true;
    firefox.enable = true;

    obs-studio = {
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

    artcraft = {
      enable = true;
      apps = [ "filmcraft" "wordcraft" "gridcraft" ];
    };

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

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 31536000;
        max-cache-ttl = 31536000;
        allow-preset-passphrase = "";
      };
    };

    #hyprland
    hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    zsh.enable = true;
    nix-ld.enable = true;
    weylus = {
      enable = true;
      users = [ "grandkahuna43325" ];
      openFirewall = true;
    };
  };


  services = {
    sunshine = {
      enable = true;
      autoStart = true; # optional: starts Sunshine automatically on login
      openFirewall = true;
    };
    # something something gnupg
    pcscd.enable = true;
    # dbus.packages = [ pkgs.gcr ];

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = true; # or use keys

    # Load nvidia driver for Xorg and Wayland
    xserver.videoDrivers = [ "nvidia" "vmware" ];

    # i3
    xserver = {
      desktopManager = {
        xterm.enable = false;
      };

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

    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = with pkgs; [ samsung-unified-linux-driver ];

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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };


  security = {
    # Enable sound with pipewire.
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.gnupg = {
      enable = true;
    };
  };


  virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;

  hardware.steam-hardware.enable = true;
  #NVIDIA
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };


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



  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    neovim
    git
    wget
    alacritty
    unzip
    ntfs3g
    wireguard-tools
    acl
    yt-dlp
    rmpc
    ffmpeg
    cifs-utils
    pulseaudio
    steam
    steam-run
    sc-controller
    protontricks
    protonup-qt
    lutris
    wine
    wineWow64Packages.waylandFull
    winetricks
    # conroller sc-controller
    pinentry-curses
    # kdePackages.xwaylandvideobridge
    weylus
    bibata-cursors

    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
