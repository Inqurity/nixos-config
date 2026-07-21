{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  xdg.configFile."wlogout".source = mkOutOfStoreSymlink "/etc/nixos/config/wlogout";
}
