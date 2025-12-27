{ config, pkgs, ... }:

{
  home.username = "phil";
  home.homeDirectory = "/home/phil";
  home.stateVersion = "25.11";

  # Start ssh-agent as a user systemd service
  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
  	claude-code
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "phpeterson-usf";
        email = "phpeterson@usfca.edu";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lh";
      la = "ls -A";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      m  = "micro";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };

    initContent = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"

      if [ -f "$HOME/.config/secrets/openai_api_key" ]; then
        export OPENAI_API_KEY="$(< $HOME/.config/secrets/openai_api_key)"
      fi
      if [ -f "$HOME/.config/secrets/anthropic_api_key" ]; then
        export ANTHROPIC_API_KEY="$(< $HOME/.config/secrets/anthropic_api_key)"
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      git_branch.symbol = "🌱 ";
      git_status = {
        ahead = "⇡";
        behind = "⇣";
        modified = "!";
        staged = "+";
      };
    };
  };

   programs.direnv = {
     enable = true;
     nix-direnv.enable = true;  # better caching for nix flakes
   };

}
