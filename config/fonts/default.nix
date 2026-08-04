{ ... }:

{
  home.file.".local/share/fonts" = {
    source = "/etc/nixos/config/fonts";
    recursive = true;
  };
}
