{ self, inputs, ... }: {
  # This is your system configuration entry-point
  flake.nixosConfigurations.nexus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nexusModule
      self.nixosModules.myHomeManager

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
  flake.nixosModules.nexusModule = { pkgs, ... }: {
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
    services.xserver.enable = true;

    # Enable KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;
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
      extraGroups = [ "networkmanager" "wheel" ];
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
    };

    environment.systemPackages = with pkgs; [
      telegram-desktop
      vesktop
      wine64
      viber
      zed-editor
      steam
      helium
      neovim
      sops
      anki
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true; # Generates the hyprland-uwsm.desktop entry for display managers
    };

    programs.fish.enable = true;

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

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = true; # The stable solution
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
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

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    home-manager.users.tem = self.homeModules.temModule;
  };
}
