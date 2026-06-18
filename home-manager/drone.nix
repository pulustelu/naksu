{ ... }:

{
  imports = [
    ./terminal.nix
  ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [ ];

  # The symlink should be for the entire folder, rather than just the karabiner.json. See:
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ../karabiner;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Olivia Palmu";
        email = "git@olivialta.cc";
      };
      revsets = {
        bookmark-advance-to = "@-";
      };
      ui = {
        default-command = "log";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
