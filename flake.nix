{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yomiyasu = {
      url = "github:nanaism/yomiyasu";
      flake = false;
    };
    # Release binary of herdr-core (hc). To update, change the version and run `nix flake update herdr-core`
    herdr-core = {
      url = "https://releases.herdr.dev/core/0.1.21/herdr-core-linux-x86_64.tar.gz";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.devbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/devbox
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.rechella = import ./home/rechella.nix;
        }
      ];
    };
  };
}
