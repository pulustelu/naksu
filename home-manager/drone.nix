{ ... }:

{
  imports = [
    ./terminal.nix
  ];

  # This symlink should be for the entire folder, rather than just the karabiner.json. See:
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

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
