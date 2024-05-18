{config, lib, ...}:
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
  services.fnott = {
    enable = true;
    settings = {
      main = {
        default-timeout = 5;
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "DP-1"
          "DP-2"
        ];
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" ];
        "clock" = {
          "format" = "{:%Y-%m-%d %H:%M %a W%V}";
          "format-alt" = "{:%a, %d. %b  %H:%M}";
        };
        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
        };
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      input = {
        "type:keyboard" = {
          "xkb_numlock" = "enabled";
          "xkb_layout"  = "us,iq";
          "xkb_options" = "grp:shift_caps_toggle";
          ## Avoid using both shifts since this is what I use to pass from
          ## virtual machine to host.
        };
      };
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
          "Mod4+Ctrl+v" = "exec cliphist list | fuzzel -d -w 50 --tabs=2 | cliphist decode | wl-copy";

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
          command = "swaybar";
          statusCommand = "while ~/.config/sway/status.sh; do sleep 1; done";
        }
      ];
      menu = "fuzzel";
      output = {
        "*" = {
          background = "~/pics/wall/babylon.jpg fill";
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
