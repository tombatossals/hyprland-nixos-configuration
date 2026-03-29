# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Imports
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  home-manager.backupFileExtension = "backup";

  # System packages
  environment.systemPackages = with pkgs; [
    wget # Descarga archivos desde HTTP/HTTPS/FTP.
    taskwarrior3 # Gestor de tareas en terminal.
    git # Control de versiones distribuido.
    btop # Monitor interactivo de sistema y procesos.
    matugen # Genera paletas de color desde imágenes.
    neovim # Editor de texto modal.
    direnv # Carga variables de entorno por directorio.
    python311 # Intérprete de Python 3.11.
    ffmpeg # Conversión y procesamiento de audio/video.
    python314 # Intérprete de Python 3.14.
    (wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { }) # Firefox con soporte PipeWire.
    hunspell # Corrector ortográfico base.
    hunspellDicts.ru_RU # Diccionario Hunspell ruso.
    hunspellDicts.es_ES # Diccionario Hunspell español.
    obsidian # App de notas en Markdown.
    p7zip # Compresión/descompresión 7z.
    papers # Visor de documentos.
    fastfetch # Información del sistema en terminal.
    quickshell # Runtime para componentes/overlays QML.
    gnome-shell-extensions # Herramientas/extensiones de GNOME Shell.
    grim # Captura de pantalla en Wayland.
    playerctl # Control multimedia vía MPRIS.
    satty # Editor/anotador para capturas.
    yq-go # Procesamiento de YAML/JSON desde CLI.
    xdg-desktop-portal-gtk # Portal GTK para apps sandboxed.
    eww # Widgets para Wayland/X11.
    swappy # Edición rápida de capturas.
    slurp # Selección de región en pantalla para Wayland.
    mpvpaper # Vídeo/fondo animado como wallpaper.
    foot # Emulador de terminal Wayland.
    gnome-tweaks # Ajustes avanzados de GNOME.
    pkgsCross.mingwW64.stdenv.cc # Toolchain GCC cruzado para Windows.
    wmctrl # Control de ventanas desde CLI.
    bottles # Gestión de apps de Windows con Wine.
    qbittorrent # Cliente BitTorrent.
    power-profiles-daemon # Perfiles de energía del sistema.
  ];

  environment.pathsToLink = [ "/share/gsettings-schemas" ];

  # User accounts and security
  users.users.dave = {
    isNormalUser = true;
    description = "dave";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "adbusers"
    ]; # Added "video" group
    packages = with pkgs; [
      #  thunderbird
    ];
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;
  system.userActivationScripts.zshrc = "touch .zshrc";

  security.sudo.extraRules = [
    {
      users = [ "dave" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };

  # Program configurations
  programs.zsh.enable = true;

  programs.adb.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.dconf = {
    enable = true;
  };

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.dave = {
    imports = [ ./home.nix ];
  };

  # Desktop environment, window managers and theme
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "dave";
  };

  # Hyprland
  programs.hyprland.enable = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Fonts
  fonts.packages = with pkgs; [
    udev-gothic-nf
    nerd-fonts.jetbrains-mono
    noto-fonts
    liberation_ttf
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font Mono"
        "Noto Sans Mono"
      ];
    };
    hinting.style = "slight";
    subpixel.rgba = "rgb";
  };

  # Flatpak
  services.flatpak.enable = true;

  # Environment Variables
  # environment.variables.XDG_DATA_DIRS = lib.mkForce "/home/dave/.nix-profile/share:/run/current-system/sw/share";

  # Networking and time
  networking.hostName = "orion";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };
  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Audio and system services
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Power Management Services
  services.power-profiles-daemon.enable = true;

  # Nix settings and maintenance
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "simple";
      themePackages = [
        (pkgs.stdenv.mkDerivation {
          pname = "plymouth-theme-simple";
          version = "1.0";

          # CHANGE THIS to the actual path of your custom theme folder
          src = /etc/nixos/config/programs/plymouth/simple;

          installPhase = ''
            mkdir -p $out/share/plymouth/themes/simple
            cp -r * $out/share/plymouth/themes/simple/

            # This dynamically replaces the @out@ placeholder with the real Nix store path
            substituteInPlace $out/share/plymouth/themes/simple/simple.plymouth \
              --replace "@out@" "$out"
          '';
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "tsc=reliable"
      "asus_wmi"
    ];
  };

  # Bootloader and kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel Packages and Optimization
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "tcp_bbr" ]; # FIX: Network Congestion Control (Helps with packet jitter)
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.core.wmem_max" = 1073741824;
    "net.core.rmem_max" = 1073741824;
    "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
    "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
  };

  # FIX: Force CPU to run at max clock speed to prevent frame-time jitter
  powerManagement.cpuFreqGovernor = "performance";

  # ==========================================
  # GPU / GRAPHICS CONFIGURATION (ADDED)
  # ==========================================

  # Gráficos — virgl para UTM en ARM
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      virglrenderer
    ];
  };

  /*
    # Load NVIDIA Drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption after suspend/wake.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures.
      # We set to false here for maximum stability on the mobile 3050.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Select the stable driver version
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # PRIME CONFIGURATION (Hybrid Graphics)
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Bus IDs derived from your lspci output
        # NVIDIA: 01:00.0 -> PCI:1:0:0
        # AMD: 04:00.0 -> PCI:4:0:0
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";
      };
    };
  */

  system.stateVersion = "25.11";
}
