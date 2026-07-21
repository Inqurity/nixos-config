{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  xdg.configFile."fuzzel".source = mkOutOfStoreSymlink "/etc/nixos/config/fuzzel";
}
