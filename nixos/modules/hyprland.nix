{ lib, ... } :
{
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
    };

    programs.uwsm = {
        enable = true;
        waylandCompositors = {
            hyprland = {
                prettyName = "Hyprland";
                binPath = "/run/current-system/sw/bin/Hyprland";
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
                command = "/run/current-system/sw/bin/Hyprland";
                user = "dylan";
            };
            default_session = initial_session;
        };
    };
}
