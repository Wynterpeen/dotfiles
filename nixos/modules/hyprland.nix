{ lib, inputs, pkgs, ... } :
with lib; let
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      #hyprbars
    ];
  };
in
{
    programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
        withUWSM = true;
    };

    environment.sessionVariables = { HYPR_PLUGIN_DIR = hypr-plugin-dir; };

    programs.uwsm = {
        enable = true;
        waylandCompositors = {
            hyprland = {
                prettyName = "Hyprland";
                binPath = "/run/current-system/sw/bin/start-hyprland";
            };
        };
    };

    programs.waybar.enable = true;

    xdg.portal.enable = true;

    # Autologin
    services.greetd = { 
        enable = true;
        settings = rec {
            initial_session = {
                command = "/run/current-system/sw/bin/start-hyprland";
                user = "dylan";
            };
            default_session = initial_session;
        };
    };

    # Cachix
    nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
}
