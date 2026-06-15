{ ... }:
{
  # tasty dev shells
  programs.direnv.enable = true;
  # Ghostty config (mac and nixos)
  xdg.configFile."ghostty/config" = {
    enable = true;
    text = ''
      theme = Ayu
      window-width = 100
      window-height = 30
    '';
  };
}
