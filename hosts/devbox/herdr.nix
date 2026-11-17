# Server side for the Herdr desktop app (Windows) to attach to devbox over SSH.
#
# - Over SSH the app finds the binary with `command -v herdr-core`, so put it on the system PATH
# - hc starts its server with `systemd-run --user`; without lingering, the user manager stops
#   when the last SSH session ends and takes the agents with it
# - The core listens only on a Unix socket ($XDG_RUNTIME_DIR/herdr-core/), so no ports to open
#
# To update: change the version in flake.nix's herdr-core.url and herdrCoreVersion below,
# then run `nix flake update herdr-core`.
# If the app offers to install hc into ~/.local/bin, decline it and update here instead.
{ inputs, pkgs, ... }:

let
  herdrCoreVersion = "0.1.21"; # keep in sync with flake.nix's inputs.herdr-core.url

  herdr-core = pkgs.callPackage ../../pkgs/herdr-core {
    src = inputs.herdr-core;
    version = herdrCoreVersion;
  };
in
{
  environment.systemPackages = [ herdr-core ];

  users.users.rechella.linger = true;
}
