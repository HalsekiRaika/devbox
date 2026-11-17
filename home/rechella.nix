{ 
  pkgs,
  inputs,
  ...
}: 
let
  yomiyasu-lint = pkgs.writeShellScriptBin "yomiyasu-lint" ''
    exec ${pkgs.python3}/bin/python3 ${inputs.yomiyasu}/scripts/yomiyasu_lint.py "$@"
  '';
in
{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    yomiyasu-lint
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

  # Agent Skills
  home.file.".claude/skills/yomiyasu".source = inputs.yomiyasu;
  home.file.".agents/skills/yomiyasu".source = inputs.yomiyasu;

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
