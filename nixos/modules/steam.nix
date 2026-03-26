{ lib, pkgs , ... }:
{
    programs.steam = {
        enable = true;
	    package = pkgs.millennium-steam; 
    };
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
}
