{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
  ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [ ];

  # karabiner-elements should NOT be installed using nix for now. maybe it works in the future.
  # karabiner can't listen for symbolic links so we need to kickstart it
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ../karabiner;
    recursive = false;
  };

  home.file.".zprofile" = {
    enable = true;
    text = ''
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    '';
  };

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
    initContent = ''
      [[ ! -f ${../p10k/.p10k.zsh} ]] || source ${../p10k/.p10k.zsh}
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # # Allow home-manager apps to be discovered by spotlight and other mac tools.
  # # This was previously handled by linkApps.
  # # If there's a permission error, try this:
  # # > I managed to work around this issue by running rm -r ~/Applications/Home\ Manager\ Apps/ before home-manager switch.
  # # (https://github.com/nix-community/home-manager/issues/8174)
  # targets.darwin.copyApps.enable = true;
  # targets.darwin.linkApps.enable = false;
}
