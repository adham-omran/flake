{pkgs, config, lib, ...}:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      nil
      wl-clipboard
      fuzzel
    ];
  };

  programs.git = {
    enable = true;
    userName  = "adham-omran";
    userEmail = "git@adham-omran.com";
    signing = {
            signByDefault = true;
            key = "4D37E0ADEE0B9138";
    };
  };

  services.blueman-applet.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      startup = [
        { command = "emacs --daemon"; }
        { command = "foot -s"; }
        { command = "wl-paste --watch cliphist store"; }
      ];
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+c" = "kill";
          "${modifier}+Shift+n" = "move left";
          "${modifier}+Shift+e" = "move down";
          "${modifier}+Shift+i" = "move up";
          "${modifier}+Shift+o" = "move right";
          "${modifier}+n" = "focus left";
          "${modifier}+e" = "focus down";
          "${modifier}+i" = "focus up";
          "${modifier}+o" = "focus right";

          "${modifier}+t" = "exec emacsclient -c";
        };
      gaps.inner = 10;
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 12.0;
      };
      terminal = "foot";
      modifier = "Mod4";
      bars = [
        {
          position = "top";
        }
      ];
      menu = "fuzzel";
      output = {
        "*" = {
          background = "/mnt/pool/home/adham/pics/wall/babylon.jpg fill";
        };
        DP-1 = {
          pos = "2560 0";
          res = "2560x1440@120Hz";
          scale = "1";
        };
      };
    };
  };
}
