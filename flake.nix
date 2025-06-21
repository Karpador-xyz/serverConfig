{
  description = "kcloud server config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05-small";
    unstable.url = "nixpkgs/nixos-unstable-small";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my own stuff
    dt = {
      url = "gitlab:Follpvosten/dt-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, deploy-rs, agenix, disko, dt }:
  let
    consts = import ./const.nix;
    mkSystem = { name, system, extraModules?[], extraSpecialArgs?{} }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (./. + "/${name}/configuration.nix")
          agenix.nixosModules.default
        ] ++ extraModules;
        specialArgs = { inherit consts; } // extraSpecialArgs;
      };
    mkNode = { name, system, ... }: let
      pkgs = import nixpkgs { inherit system; };
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlays.default
          (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
        ];
      };
    in {
      sshUser = "root";
      hostname = name;
      profiles.system = {
        user = "root";
        path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations."${name}";
      };
    };
    systems = {
      kcloud-nix = rec {
        name = "kcloud-nix";
        system = "aarch64-linux";
        extraSpecialArgs = {
          dtPkgs = dt.packages."${system}";
          unstable = unstable.legacyPackages."${system}";
        };
      };
      karp-zbox = rec {
        name = "karp-zbox";
        system = "x86_64-linux";
        extraSpecialArgs.unstable = unstable.legacyPackages."${system}";
      };
      bakapa = {
        name = "bakapa";
        system = "x86_64-linux";
        extraModules = [ disko.nixosModules.disko ];
      };
      moo = {
        name = "moo";
        system = "x86_64-linux";
      };
    };
  in {
    nixosConfigurations = builtins.mapAttrs (_name: system: mkSystem system) systems;
    deploy.nodes = builtins.mapAttrs (_name: system: mkNode system) systems;

    # comment out if you don't have an aarch64 builder instance or
    # `boot.binfmt.emulatedSystems = [ "aarch64-linux" ];` set
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    devShells.x86_64-linux.default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = [
        nixpkgs.legacyPackages.x86_64-linux.deploy-rs
        agenix.packages.x86_64-linux.default
      ];
    };
  };
}
