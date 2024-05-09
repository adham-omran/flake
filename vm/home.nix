{pkgs, config, lib, ...}:
{
  home = {
    stateVersion = "23.11";
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
      focus.wrapping = "workspace";
      startup = [
        { command = "emacs --daemon"; }
        { command = "foot -s"; }
        { command = "wl-paste --watch cliphist store"; }
      ];
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+n" = "move left";
          "${modifier}+Shift+e" = "move down";
          "${modifier}+Shift+i" = "move up";
          "${modifier}+Shift+o" = "move right";
          "${modifier}+n" = "focus left";
          "${modifier}+e" = "focus down";
          "${modifier}+i" = "focus up";
          "${modifier}+o" = "focus right";
          "${modifier}+Comma" = "focus output left";
          "${modifier}+Period" = "focus output right";
          "Print" = "exec wl-copy < $(grimshot save area ~/pics/Screenshots/screenshot-$(date --iso-8601=s).png)";

          "${modifier}+c" = "kill";
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
          fonts = {
            names = [ "JetBrains Mono" ];
            size = 12.0;
          };
          command = "waybar";
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
        DP-2 = {
          pos = "0 0";
          res = "2560x1440@120Hz";
          scale = "1";
        };
      };
    };
  };
}

# Local Variables:
# jinx-local-words: "JetBrains adham babylon cliphist emacs emacsclient fuzzel jpg mnt omran wl"
# End:
