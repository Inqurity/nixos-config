{ self, inputs, ... }: {

  # This is your standalone home-manager configuration, meant to be used on non-nixos machines
  # with the home-manager command
  flake.homeConfigurations.tem = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.temModule
      {
        home.username = "tem";
        home.homeDirectory = "/home/tem";
      }
    ];
  };

  # This is your home.nix, your module where you configure home-manager
  # It's imported both in standalone configuration above, and in your nixos configuration
  flake.homeModules.temModule = { pkgs, inputs, ... }:
  let
    # 1. Define the path to your programs directory
    programsDir = /etc/nixos/config;
  
    # 2. Get the content of the directory
    files = builtins.readDir programsDir;
  
    # 3. Filter for directories only (ignoring regular files like .DS_Store or READMEs)
    directories = builtins.filter 
      (name: files.${name} == "directory") 
      (builtins.attrNames files);
  
    # 4. Map the directory names to import paths
    programImports = map (name: programsDir + "/${name}") directories;
  in {
    imports = [
     # (import /etc/nixos/config/quickshell/build.nix {inherit pkgs inputs ;})
    ] ++ programImports; # straight out of ilyamiro's config
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "tem";
    home.homeDirectory = "/home/tem";
  
    home.packages = with pkgs; [                               
      # my shit
      git
      btop
      fastfetch
      vlc
      unrar
      noctalia-shell
      python314Packages.kde-material-you-colors
      kdePackages.knewstuff
      
      ntfs3g
      udiskie
      grim
      inetutils
      libnotify
      dbus
      xlsclients
      kdePackages.kconfig
      lxqt.pavucontrol-qt
      wireplumber
      libdbusmenu-gtk3
      playerctl
      (geoclue2.override {withDemoAgent = true; })
      brightnessctl
      ddcutil
      bc
      uutils-coreutils-noprefix
      cmake
      curlFull
      wget
      ripgrep
      jq
      xdg-user-dirs
      rsync
      yq-go
      bibata-cursors
      adw-gtk3
      kdePackages.breeze
      kdePackages.breeze-icons
      darkly
      eza
      fontconfig
      matugen
      starship
      nerd-fonts.jetbrains-mono
      material-symbols
      rubik
      twemoji-color-font
      hyprsunset
      wl-clipboard
      kdePackages.bluedevil
      networkmanager
      kdePackages.plasma-nm
      kdePackages.dolphin
      kdePackages.systemsettings
      kdePackages.kdialog

      uv
      gtk4
      libadwaita
      libsoup_3
      libportal-gtk4
      gobject-introspection
      hyprshot
      slurp
      swappy
      tesseract
      wf-recorder
      upower
      wtype
      ydotool
      fuzzel
      glib
      imagemagick
      hypridle
      hyprpicker
      translate-shell
      wlogout
      libqalculate
      noctalia-shell
    ] ++ [
      #(config.lib.nixGL.wrap pkgs.hyprland)
  
      ### illogical-impulse-quickshell-git
      #(config.lib.nixGL.wrap quickshell.packages.x86_64-linux.default)
      (import /etc/nixos/config/quickshell/build.nix { inherit pkgs quickshell inputs; 
      #nixGLWrap = config.lib.nixGL.wrap;
      })
      ];
  
    programs.kitty = {
      enable = true;
      settings = {
        cursor_trail = 1;
	include = "matugen-colors.conf";
	window_padding_width = 16;
      };
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  	#  wayland.windowManager.hyprland.settings = {
  	#    "$mod" = "SUPER";
  	#    bind =
  	#      [
  	#        "$mod, F, exec, helium"
  	# "$mod, T, exec, kitty"
  	#        ", Print, exec, grimblast copy area"
  	#      ]
  	#      ++ (
  	#        # workspaces
  	#        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
  	#        builtins.concatLists (builtins.genList (i:
  	#            let ws = i + 1;
  	#            in [
  	#              "$mod, code:1${toString i}, workspace, ${toString ws}"
  	#              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
  	#            ]
  	#          )
  	#          9)
  	#      );
  	#  };
    services.hyprpolkitagent.enable = true;
  
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "26.05";
  
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
