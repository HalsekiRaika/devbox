{ 
  pkgs,
  ...
}: 
{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
  ];
  
  programs.direnv = { 
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
    '';
  };
  programs.starship = { enable = true; enableNushellIntegration = true; };
  programs.zoxide   = { enable = true; enableNushellIntegration = true; };
  programs.atuin    = { enable = true; enableNushellIntegration = true; };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "RechellaTek";
        email = "reirokusanami.rdh@gmail.com";
      };
    };
    ignores = [
      ".envrc"
      ".direnv/"
    ];
  };

  programs.zed-editor = {
    enable = true;
    package = null;
    userSettings = {
      load_direnv = "direct";
      lsp.rust-analyzer = {
        binary.path_lookup = true;
        initialization_options.check.command = "clippy";
      };
    };
    installRemoteServer = true;   # ~/.zed_server に nixpkgs 版のリモートサーバーを置く
  };
}
