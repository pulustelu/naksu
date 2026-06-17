{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    # Darwin + nixos shared inputs:
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-darwin,
      nix-darwin,
      home-manager,
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#pigeon
      darwinConfigurations."pigeon" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.olivia = import ./home-manager/pigeon.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
        specialArgs = { inherit inputs; };
      };
      darwinConfigurations."drone" = nix-darwin.lib.darwinSystem {
        modules = [
          ({ pkgs, ... }: {
            environment.systemPackages = with pkgs; [
              # basic tooling
              gh
              forgejo-cli
              jujutsu
              gram
              ripgrep
              python314
              # work tooling
              awscli
              bkt
              jq
              ssm-session-manager-plugin
              _1password-cli
              # languages
              rustup # preferred to let it install its own versions
              metals # scala LSP
              nil # nix LSP
            ];
            homebrew = {
              enable = true;
              brews = [
                "nvm"
              ];
              casks = [
                "corretto@21"
                "stats"
                "ghostty"
                "karabiner-elements"
              ];
            };

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 6;

            # use touch id for sudo prompts
            security.pam.services.sudo_local.touchIdAuth = true;

            # nix-darwin no longer runs implicitly as the current user
            system.primaryUser = "olivia.palmu";

            # necessary for vscode
            nixpkgs.config.allowUnfree = true;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
          })
        ];
        specialArgs = { inherit inputs; };
      };
      # Build nixos flake using:
      # $ nixos-rebuild build --flake .#magpie
      nixosConfigurations."magpie" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # hm file overwrite backups
            home-manager.backupFileExtension = "home-manager-backup";
            home-manager.users.olivia = ./home-manager/magpie.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
