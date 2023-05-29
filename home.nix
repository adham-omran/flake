{config, pkgs, lib, ...}:
{
  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
      # DSLR Webcam
      # gphoto2
      # mptlvcap (arch-distrobox) works better

      # General
      graphviz
      openssl
      git
      stow
      kitty
      oh-my-posh
      zotero

      # KVM/Streaming
      sunshine
      moonlight-qt
      barrier

      # Music
      playerctl
      ncmpcpp
      spotify

      # Communication
      discord
      telegram-desktop
      element-desktop

      # Video/Audio
      mpv
      ffmpeg
      qpwgraph

      # LaTeX
      texlive.combined.scheme-full

      # LibreOffice
      libreoffice-qt

      # Clojure
      clojure
      leiningen
      clojure-lsp

      # direnv
      direnv

      # Drawing tablet
      rnote
      xournalpp

      # Web
      google-chrome
      nyxt

      # Spelling
      hunspell
      hunspellDicts.en_US

      # KDE Applications
      libsForQt5.kcalc
      libsForQt5.kclock

      # Provide gtk-launch
      gtk3

      # Utilities
      pass
      tree
      ledger
      neofetch
      bat
      htop
      btop
      fd
      dmidecode # RAM stuff
      powertop
      wget
      poppler_utils # PDF utilities

      # gnuplot
      gnuplot

      # bitwarden
      bitwarden

      # Applications
      poedit
      foliate

      # GNOME Theme
      paper-gtk-theme
      pop-gtk-theme
      gnome.adwaita-icon-theme
      gnome.gnome-tweaks

      # PDF Reader
      zathura

      # File manager
      cinnamon.nemo

      # WM Utilities
      brightnessctl
      libnotify
      mako
      pavucontrol
      pfetch
      slurp
      sway-contrib.grimshot
      swaybg
      wf-recorder
      wl-clipboard
      wofi

      # Virtual pointer
      warpd

      # Downloaders
      qbittorrent

      # WakaTime
      wakatime

      # Anki
      anki

      # Rice
      eww-wayland

      # Distrobox
      distrobox

      # OBS
      obs-studio

      # X11
      arandr    # multi-monitor
      flameshot # screenshot
      feh       # background
      dunst     # notifications
      polybar   # bar
      rofi      # launcher
      ffcast    # screencast
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

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-size=20
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "palenight";

  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "/home/adham/music";
    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = 9900;
      execute_on_song_change = "notify-send \"Now Playing\" \"$(mpc -p 9900 --format '%title% \\n%artist% - %album%' current)\"";
    };
  };
}

# Local Variables:
# jinx-local-words: "xournalpp"
# End:
