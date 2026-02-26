{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #millennium.url = "git+https://github.com/SteamClientHomebrew/Millennium";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    configuration = { pkgs, config, ... }: {
      
      # systemd.extraConfig = "DefaultLimitNOFILE=8192:524288";
      #nixpkgs.overlays = [ inputs.millennium.overlays.default ];
      imports =
      [
        ./hardware-configuration.nix
        ./modules/hyprland.nix
        ./modules/steam.nix
      ];
      hardware.enableAllFirmware = true;
      
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      services.udev.extraRules = ''
      	KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0e20", MODE="0660", GROUP="K39", TAG+="uaccess", TAG+="udev-acl"
      '';
	
      services.blueman.enable = true;

      #Nvidia
      services.xserver.videoDrivers = ["nvidia"];
      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
	      nvidiaSettings = false;
      };


      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        git
        mpv
        zathura
        # libreoffice
        fastfetch
        mangohud
        vesktop
        # lutris
        syncthing
        vscode
        # wireshark-qt
        swww #wallpaper deamon
        kitty
        rofi
        # protonup
        networkmanagerapplet
        hyprland-qtutils
        dunst
        #nemo
        nautilus
        btop
        obsidian
        ftb-app
        librewolf
        # krita
        # obs-studio
        # anki
        keepassxc
        # r2modman
        # protontricks
        chromium
        bibata-cursors
        gruvbox-plus-icons
        deadlock-mod-manager
      ];
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      
      # Bootloader
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Network
      networking.hostName = "K39";
      networking.networkmanager.enable = true;

      # Set time zone
      time.timeZone = "Europe/Amsterdam";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.supportedLocales = [ "all" ];

      # Enable CUPS to print documents.
      services.printing.enable = true;  
      
      # Needed for file manager
      services.gvfs.enable = true; 

      # Enable audio
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };  

      users.users.K39 = {
        isNormalUser = true;
        description = "";
        extraGroups = [ "networkmanager" "wheel" "audio" ];
      };

      programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
        shellAliases = {
          rebuild = "sudo nixos-rebuild switch";
        };
      };
      users.defaultUserShell = pkgs.zsh;

      # Text editor
      programs.nano.enable = false;
      programs.vim.enable = true;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "delete-older-than 30d";
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

      system.stateVersion = "25.05";  
    };
  in
  {
    nixosConfigurations = {
      terra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ configuration ];
      };
      K39 = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [ configuration ];
      };
    };
  };
}
