# serverConfig
here be built the server config for le karp a door.

## initial setup
unfortunately because I'm probably migrating to an ARM server, that complicates
some things. basically, in order to get the checks against the config to work,
the local system needs some way to build aarch64-linux packages.

the simplest way on NixOS is to set
`boot.binfmt.emulatedSystems = [ "aarch64-linux" ];`.

alternatively, a remote builder can be configured via `nix.buildMachines`.

or go crazy and comment out the `checks = …` line in flake.nix.

## run a deploy
with direnv, it should be enough to `deploy .` in the root of this repo.
(requires a valid ssh key for root on the server atm.)

and yes, deploy-rs will be compiled. I am sorry.
