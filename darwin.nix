{ pkgs, inputs, ... }:
{
  # originally from home.nix, needs to be defined outside home-manager due to bees apparently
  users.users.olivia.home = "/Users/olivia";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    rustup
    cbqn-replxx
    typst
    gram
    nil # nix language server
    jujutsu
    ripgrep
    gh
    forgejo-cli
    ffmpeg
    nodejs
    (python313.withPackages (
      ps: with ps; [
        ipykernel
        numpy
        matplotlib
      ]
    ))
  ];

  # Nix-related configuration
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      automatic = true;
      # interval defaults to sunday 03:15
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      # interval defaults to sunday 03:15
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # yey
  networking.hostName = "pigeon";

  # Required in later versions of nix-darwin
  system.primaryUser = "Olivia";
  # settings
  system.defaults = {
    # Don't navigate back and forward with two-finger scroll
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
    # Use 1,234.56 number format
    CustomSystemPreferences.NSGlobalDomain.AppleICUNumberSymbols = {
      "0" = ".";
      "1" = ",";
      "10" = ".";
      "17" = ",";
    };
    # Use dark theme
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    # Show hidden files
    NSGlobalDomain.AppleShowAllFiles = true;
    finder.AppleShowAllFiles = true;
    # But don't show all extensions
    NSGlobalDomain.AppleShowAllExtensions = false;
    finder.AppleShowAllExtensions = false;
    # Don't expand cursor when wiggling
    CustomUserPreferences.NSGlobalDomain.CGDisableCursorLocationMagnification = true;
    # Key repeat settings: fastest
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    # Don't autocorrect!
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    CustomUserPreferences.NSGlobalDomain.NSAutomaticTextCompletionEnabled = 0;
    CustomUserPreferences.NSGlobalDomain.WebAutomaticSpellingCorrectionEnabled = 0;
    # Prefer DDG
    CustomUserPreferences.NSGlobalDomain.NSPreferredWebServices.NSWebServicesProviderWebSearch = {
      NSDefaultDisplayName = "DuckDuckGo";
      NSProviderIdentifier = "com.duckduckgo";
    };
    # Pretty swell double click threshold
    CustomUserPreferences.NSGlobalDomain."com.apple.mouse.doubleClickThreshold" = "0.5";
    # No natural scroll
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    # Fast trackpad
    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
    # Single tap click
    trackpad.Clicking = true;
    # Disable four and five finger pinch
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadFiveFingerPinchGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadFourFingerPinchGesture = 0;
    # Enable three finger drag and disable all other uses of it
    trackpad.TrackpadThreeFingerDrag = true;
    trackpad.TrackpadThreeFingerTapGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadThreeFingerHorizSwipeGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadThreeFingerVertSwipeGesture = 0;
    # Disable control center from the right edge
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadTwoFingerFromRightEdgeSwipeGesture =
      0;
    # DON'T AUTOMATICALLY FUCK UP MY KEYBOARD LAYOUT
    CustomUserPreferences."com.apple.HIToolbox".AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput =
      0;
    # I would prefer not to click to show desktop
    WindowManager.EnableStandardClickToShowDesktop = false;
    # Hide dock
    dock.autohide = true;
    # DO NOT REARRANGE MY SPACES!!
    dock.mru-spaces = false;
    # No recent apps in dock
    dock.show-recents = false;
    # Hot corners: Bottom right = Show desktop
    dock.wvous-br-corner = 4;
    # Prefer column view in finder
    finder.FXPreferredViewStyle = "clmv";
    # Open ~ on new finder window
    finder.NewWindowTarget = "Home";
    # Enable iCloud Drive to sync desktop and documents
    CustomUserPreferences."com.apple.finder".FXICloudDriveDesktop = 1;
    CustomUserPreferences."com.apple.finder".FXICloudDriveDocuments = 1;
    # Don't show status bar at the bottom in finder
    finder.ShowStatusBar = false;
    # Sort folders first in finder
    finder._FXSortFoldersFirst = true;
  };
  # Allow touchid in sudo prompts
  security.pam.services.sudo_local.touchIdAuth = true;
  # Add p10k font
  fonts.packages = [
    pkgs.meslo-lgs-nf
  ];
  # homebrew here
  homebrew = {
    enable = true;
    # I don't care about idempotent behavior I just wanna have my apps up to date
    onActivation = {
      # update brew formulae
      autoUpdate = true;
      # upgrade packages
      upgrade = true;
    };
    brews = [ ];
    casks = [
      "arduino-ide"
      "audacity"
      "blender"
      "discord"
      "dyalog"
      "firefox"
      "ghostty"
      "gimp"
      "godot"
      "karabiner-elements"
      "obs"
      "prismlauncher"
      "proton-drive"
      "protonvpn"
      "signal"
      "spotify"
      "stats"
      "steam"
      "tailscale-app"
      "telegram"
      "ukelele"
      "zotero"
    ];
  };
}
