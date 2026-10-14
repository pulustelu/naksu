{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
  ];

  # This symlink should be for the entire folder, rather than just the karabiner.json. See:
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ../karabiner;
    recursive = false;
  };

  # this may be causing some issues with conflicting files -- macos maybe creates some /etc entries for zsh?
  programs.zsh = {
    enable = true;
    shellAliases = {
      pigeon-switch = "sudo darwin-rebuild switch --flake ~/.config/nix";
      pigeon-update = "nix flake update nixpkgs-darwin --flake ~/.config/nix";
      pigeon-fetch = "cd ~/.config/nix && jj git fetch && jj new main && cd -";
      pigeon-push = "cd ~/.config/nix && jj commit -m 'Bump pigeon' && jj tug && jj git push && cd -";
      pigeon-bump = "pigeon-fetch && pigeon-update && pigeon-switch && pigeon-push";
    };
    # Initialize p10k configuration (took a while to find the config line because the wizard doesn't tell you)
    # also homebrew
    # also direnv
    initContent = ''
      [[ ! -f ${../p10k/.p10k.zsh} ]] || source ${../p10k/.p10k.zsh}
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      eval "$(direnv hook zsh)"
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
