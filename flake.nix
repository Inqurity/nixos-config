{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-parts, sops-nix, home-manager, quickshell, qylock, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);/*: {
    
    perSystem = { self', inputs', pkgs, system }: {
      packages = {
        illogical-impulse-quickshell-wrapper = pkgs.callPackage /etc/nixos/config/quickshell/build.nix {
          quickshell = inputs'.quickshell;
	};
      };
      /*nixosConfigurations.nexus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
	modules = [ 
	  ./configuration.nix
	  sops-nix.nixosModules.sops
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs; inherit quickshell; };
	    home-manager.users.tem = ./home.nix;
	    home-manager.backupFileExtension = "bak";
	  }
	];
      };
    };*/
}
