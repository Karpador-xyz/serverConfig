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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # my own stuff
    dt = {
      url = "gitlab:Follpvosten/dt-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self, nixpkgs, unstable, deploy-rs, agenix, disko, dt, nixos-hardware
  }@inputs:
  let
    consts = import ./const.nix;
    mkSystem = { name, system, extraModules?[], extraSpecialArgs?{}, ... }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (./. + "/${name}/configuration.nix")
          agenix.nixosModules.default
        ] ++ extraModules;
        specialArgs = {
          inherit consts inputs;
          unstable = unstable.legacyPackages."${system}";
        } // extraSpecialArgs;
      };
    mkNode = { name, system, extraProfiles?{}, ... }: let
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
      # always deploy the "system" profile first
      profilesOrder = [ "system" ];
      profiles = {
        system = {
          user = "root";
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations."${name}";
        };
      } // builtins.mapAttrs (_name: f: f nixpkgs deployPkgs) extraProfiles;
    };
    systems = {
      kcloud-nix = rec {
        name = "kcloud-nix";
        system = "aarch64-linux";
        extraSpecialArgs = {
          dtPkgs = dt.packages."${system}";
          unstable = import unstable {
            inherit system;
            # mautrix-discord pulls this in even when not using encryption
            config.permittedInsecurePackages = ["olm-3.2.16"];
          };
        };
      };
      karp-zbox = {
        name = "karp-zbox";
        system = "x86_64-linux";
      };
      bakapa = {
        name = "bakapa";
        system = "x86_64-linux";
        extraModules = [ disko.nixosModules.disko ];
      };
      moo = {
        name = "moo";
        system = "x86_64-linux";
        extraProfiles.update-mailcow = nixpkgs: deployPkgs: {
          user = "root";
          activationTimeout = 600;
          confirmTimeout = 60;
          autoRollback = false;
          magicRollback = false;
          path = deployPkgs.deploy-rs.lib.activate.custom
            (import ./moo/update-mailcow.nix nixpkgs)
            "./bin/activate";
        };
      };
      boop = {
        name = "boop";
        system = "x86_64-linux";
        extraModules = [
          disko.nixosModules.disko
          nixos-hardware.nixosModules.hardkernel-odroid-h3
        ];
      };
    };
  in {
    nixosConfigurations = builtins.mapAttrs (_name: system: mkSystem system) systems;
    deploy.nodes = builtins.mapAttrs (_name: system: mkNode system) systems;

    # comment out if you don't have an aarch64 builder instance or
    # `boot.binfmt.emulatedSystems = [ "aarch64-linux" ];` set
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    # this is how you create a VM image
    #packages.x86_64-linux = {
    #  bakapa-image = self.nixosConfigurations.bakapa.config.system.build.diskoImages;
    #};

    devShells.x86_64-linux.default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = [
        nixpkgs.legacyPackages.x86_64-linux.deploy-rs
        agenix.packages.x86_64-linux.default
      ];
    };
  };
}
