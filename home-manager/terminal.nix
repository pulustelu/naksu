{ ... }:
{
  # Ghostty config (mac and nixos)
  xdg.configFile."ghostty/config" = {
    enable = true;
    text = ''
      theme = Ayu
    '';
  };
}
