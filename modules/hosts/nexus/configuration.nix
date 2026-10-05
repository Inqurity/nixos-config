{ self, inputs, ... }: {
  # This is your system configuration entry-point
  flake.nixosConfigurations.nexus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nexusModule
      self.nixosModules.myHomeManager
      inputs.nixos-hardware.nixosModules.asus-fx506hm

      inputs.qylock.nixosModules.default ({ pkgs, ... }: {
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;

        programs.qylock = {
          enable = true;
          theme = "man-bicycle"; # any directory name under themes/
          # sddm.enable = true;     # installs theme + sets it active (default)
          # quickshell.enable = true; # adds `qylock-lock` to PATH (default)

          # Optional per-theme tweaks (replaces the interactive prompts):
          /*
          themeOptions = {
            terraria.backgroundMode = "time"; # time | random | static
            Genshin.backgroundMode = "time";
            clockwork.orbital = {
              themeMode = "dark";
              enableWindup = true;
            };
            osu.gameMode = "menu"; # menu | game
          };
          */
        };
      })
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.nexusModule = { pkgs, config, ... }: {
    imports = [
      # Include the results of the hardware scan.
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = /etc/nixos/secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/tem/.config/sops/age/keys.txt";
      secrets = {
        tailscale = { };
      };
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nexus"; # Define your hostname.
    # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Kyiv";

    # Select internationalisation properties.
    i18n.defaultLocale = "pl_PL.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    # services.xserver.enable = true;
		
    #obs virtual cam
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];

    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';

    # Enable KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [ 
      discover
      elisa
      spectacle
      kwin
      kwin-x11
      konsole
      plasma-desktop
      plasma-workspace
    ]; 

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh";
    };

    # Enable CUPS to print documents.
    # services.printing.enable = true;
    services.blueman.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      #
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."tem" = {
      isNormalUser = true;
      description = "tem";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "cdemu" "cdrom" ];
      packages = with pkgs; [
        # kdePackages.kate
        # thunderbird
      ];
    };

    nixpkgs.overlays = [
      inputs.helium.overlays.default
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    services = {
      tailscale = {
        enable = true;
        authKeyFile = "/run/secrets/tailscale";
      };
      asusd.enable = true;
      cloudflare-warp.enable = true;
    };

    hardware.asus.battery = {
      chargeUpto             = 80;   # Maximum level of charge for your battery, as a percentage.
      enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 85` temporarily sets the charge limit to 85%.
    };

    environment.systemPackages = with pkgs; [
      gcc
      gnumake
      telegram-desktop
      vesktop
      wine64
      wine
      viber
      zed-editor
      steam
      helium
      neovim
      sops
      anki
      asusctl
      ffmpeg
    ];

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["tem"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true; # Generates the hyprland-uwsm.desktop entry for display managers
    };

    programs.fish.enable = true;

    programs.cdemu.enable = true;

    users.extraUsers.tem = {
      shell = pkgs.fish;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # Enable OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default settings for stateful data
    # were taken.
    system.stateVersion = "26.05"; # Did you read the comment?

    # === NVIDIA CONFIGURATION FOR LAPTOP ===
		  hardware.graphics = {
		    enable = true;
		    enable32Bit = true;
		  };

		#   services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
		#
		#   hardware.nvidia = {
		#     modesetting.enable = true;
		#     nvidiaSettings = true;
		#     open = true;
		#     # package = config.boot.kernelPackages.nvidiaPackages.stable;
		#
		#     prime = {
		#       # sync.enable = true; # The stable solution
		# offload = {
		#     	  enable = true;
		#     	  enableOffloadCmd = true;
		#   	};
		#
		#       intelBusId = "PCI:0:2:0";
		#       nvidiaBusId = "PCI:1:0:0";
		#     };
		#   };
		#
		#   boot.extraModprobeConfig = ''
		#     blacklist nouveau
		#     options nouveau modeset=0
		#   '';
		#
		#   services.udev.extraRules = ''
		#     # Remove NVIDIA USB xHCI Host Controller devices, if present
		#     ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
		#     # Remove NVIDIA USB Type-C UCSI devices, if present
		#     ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
		#     # Remove NVIDIA Audio devices, if present
		#     ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
		#     # Remove NVIDIA VGA/3D controller devices
		#     ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
		#   '';
		#   boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
    # === END OF NVIDIA CONFIGURATION ===

    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;
    services.libinput.touchpad.naturalScrolling = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings.General = {
        Experimental = true;
      };
    };

    # laptop
    
    # powerManagement.enable = true;
    # services.thermald.enable = true;
    # services.tlp = {
    #   enable = true;
    #   settings = {
    # 	CPU_SCALING_GOVERNOR_ON_AC = "performance";
    # 	CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #
    # 	CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    # 	CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #
    # 	CPU_MIN_PERF_ON_AC = 0;
    # 	CPU_MAX_PERF_ON_AC = 100;
    # 	CPU_MIN_PERF_ON_BAT = 0;
    # 	CPU_MAX_PERF_ON_BAT = 20;
    #
    # 	# Optional helps save long term battery health
    #     START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
    #     STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
    #   };
    # };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    home-manager.users.tem = self.homeModules.temModule;
  };
}
