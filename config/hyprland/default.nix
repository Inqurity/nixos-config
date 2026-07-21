{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
  };

  xdg.configFile."hypr".source = "/etc/nixos/config/hyprland";
  xdg.configFile."hypr".recursive = true;
}
