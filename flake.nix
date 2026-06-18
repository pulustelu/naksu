{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    {
      darwinConfigurations."pigeon" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.olivia = import ./home-manager/pigeon.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };

      darwinConfigurations."drone" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."olivia.palmu" = import ./home-manager/drone.nix;
          }
          ({ pkgs, ... }: {
            system.primaryUser = "olivia.palmu";
            users.users."olivia.palmu".home = "/Users/olivia.palmu";
            nixpkgs.hostPlatform = "aarch64-darwin";

            environment.systemPackages = with pkgs; [
              # basic tooling
              gh
              forgejo-cli
              jujutsu
              gram
              ripgrep
              python314
              direnv
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

            # use touch id for sudo prompts
            security.pam.services.sudo_local.touchIdAuth = true;

            nixpkgs.config.allowUnfree = true;

            nix = {
              settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              optimise = {
                automatic = true;
                # interval defaults to every sunday 03:15
              };
              gc = {
                automatic = true;
                options = "--delete-older-than 7d";
                # interval defaults to every sunday 03:15
              };
            };

            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.stateVersion = 6;
          })
        ];
        specialArgs = { inherit inputs; };
      };

      nixosConfigurations."magpie" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # TODO: hm file overwrite backups -- needed?
            home-manager.backupFileExtension = "home-manager-backup";
            home-manager.users.olivia = ./home-manager/magpie.nix;
          }
        ];
      };
    };
}
