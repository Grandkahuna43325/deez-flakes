# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, pkgsUnstable, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # make unstable available
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
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

  services = {
    # ssh
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    # sound
    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraConfig = "load-module module-combine-sink";
    };

    pipewire = {
      enable = false;
      alsa.enable = false;
      alsa.support32Bit = false;
      pulse.enable = false;
    };


    # x11
    xserver = {
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "pl";
        variant = "";
      };

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
    }; # --

    # screen sharing
    sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
    };


    # something something gnupg
    pcscd.enable = true;
    dbus.packages = [ pkgs.gcr ];

    blueman.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    displayManager.defaultSession = "hyprland";

    # services.openvpn.servers = {
    #   homeVPN = { config = '' config /home/grandkahuna43325/.config/openvpn/home.conf ''; };
    # };

    # Enable the KDE Plasma Desktop Environment.
    # displayManager.sddm.enable = true;
    # desktopManager.plasma6.enable = true;
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };

    weylus = {
      enable = true;
      users = [ "grandkahuna43325" ];
      openFirewall = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

  };

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };

  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.grandkahuna43325 = {
      isNormalUser = true;
      description = "Grandkahuna43325";
      extraGroups = [ "networkmanager" "wheel" "audio" "input" "uinput" ];
      packages = with pkgs; [
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  # Configure console keymap
  console.keyMap = "pl2";


  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pkgsUnstable.neovim
    git
    wget
    alacritty
    unzip
    pinentry-curses
    weylus
    # cloudflare-warp
    # cloudflared
  ];

  # Open ports in the firewall.
  networking = {
    hostName = "nixosLaptop";

    # Enable networking
    networkmanager.enable = true;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8081 ]; # Allow HTTP, HTTPS and OBS Teleport
      allowedUDPPorts = [ 8081 ];
      # Allow OBS Teleport traffic through the firewall
      allowedTCPPortRanges = [
        { from = 8081; to = 8081; }
      ];
      allowedUDPPortRanges = [
        { from = 8081; to = 8081; }
      ];
    };
  };


  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [
      "*"
    ];


    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  environment.variables.EDITOR = "nvim";


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  #GRAVEYARD

  #NVIDIA
  # Enable OpenGL
  # hardware.opengl = {
  #   enable = true;
  # };

  # systemd.packages = [ pkgs.cloudflare-warp ]; # for warp-cli
  # systemd.targets.multi-user.wants = [ "warp-svc.service" ]; # causes warp-svc to be started automatically

  # services.cloudflare-warp.enable = true;
  #   services.cloudflare-warp = {
  #   enable = true;
  #
  #   # @TODO - Need a better way to handle this
  #   certificate = "/home/grandkahuna43325/.config/cloudflare/warp/cert/Cloudflare_CA.crt";
  # };


}
