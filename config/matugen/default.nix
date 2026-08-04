{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  xdg.configFile."matugen".source = mkOutOfStoreSymlink "/etc/nixos/config/matugen";
}

