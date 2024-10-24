{
  description = "kcloud server config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05-small";
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

  outputs = { self, nixpkgs, unstable, deploy-rs, agenix, disko, dt }: {
    nixosConfigurations = {
      kcloud-nix = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        modules = [
          ./kcloud/configuration.nix
          agenix.nixosModules.default
        ];
        specialArgs = {
          dtPkgs = dt.packages."${system}";
          unstable = unstable.legacyPackages."${system}";
        };
      };
      karp-zbox = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./karp-zbox/configuration.nix
          agenix.nixosModules.default
        ];
        specialArgs = {
          unstable = unstable.legacyPackages."${system}";
        };
      };
      bakapa = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./bakapa/configuration.nix
          agenix.nixosModules.default
          disko.nixosModules.disko
        ];
      };
    };

    deploy.nodes = let mkNode = name: arch: {
      sshUser = "root";
      hostname = name;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib."${arch}-linux".activate.nixos self.nixosConfigurations."${name}";
      };
    }; in {
      kcloud-nix = mkNode "kcloud-nix" "aarch64";
      karp-zbox = mkNode "karp-zbox" "x86_64";
      bakapa = mkNode "bakapa" "x86_64";
    };

    # comment out if you don't have an aarch64 builder instance or
    # `boot.binfmt.emulatedSystems = [ "aarch64-linux" ];` set
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    devShells.x86_64-linux.default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = [
        deploy-rs.packages.x86_64-linux.deploy-rs
        agenix.packages.x86_64-linux.default
      ];
    };
  };
}
