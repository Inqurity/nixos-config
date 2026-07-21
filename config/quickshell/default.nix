{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  xdg.configFile."quickshell".source = mkOutOfStoreSymlink "/etc/nixos/config/quickshell";
  xdg.configFile."quickshell".recursive = true;
}
