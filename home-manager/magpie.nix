{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
  ];

  # home-manager basic info
  home.username = "olivia";
  home.homeDirectory = "/home/olivia";

  home.packages = [
    (pkgs.writeShellScriptBin "magpie-update" "nix flake update nixpkgs --flake ~/.config/nix")
    (pkgs.writeShellScriptBin "magpie-switch" "sudo nixos-rebuild switch --flake ~/.config/nix")
    (pkgs.writeShellScriptBin "magpie-fetch" "cd ~/.config/nix && jj git fetch && jj new main && cd -")
    (pkgs.writeShellScriptBin "magpie-push" "cd ~/.config/nix && jj commit -m 'Bump magpie' && jj tug && jj git push && cd -")
    (pkgs.writeShellScriptBin "magpie-bump" "magpie-fetch && magpie-update && magpie-switch && magpie-push")
  ];

  # ghostty (pigeon uses brew to install)
  programs.ghostty.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
