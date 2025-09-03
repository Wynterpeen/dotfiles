{ lib, pkgs , ... }:
{
    programs.steam = {
        enable = true;
        package = pkgs.steam-millennium;
    };
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
}