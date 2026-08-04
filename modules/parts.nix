{ inputs, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
  
  config.systems = ["x86_64-linux"];
}
