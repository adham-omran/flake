{config, pkgs, lib, ...}:
{
  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
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
      ## Can't use with Spotify at the moment.
      ## The perfect state would be to use Spotify under ncmpcpp.
      playerctl
      ncmpcpp
      spotify
      mopidy
      mopidy-mopify

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

      # Spelling
      hunspell
      hunspellDicts.en_US

      # KDE Applications
      libsForQt5.kcalc
      libsForQt5.kclock

      # Provide gtk-launch
      gtk3

      # Utilities
      ledger
      neofetch
      bat
      htop
      btop
      fd
      dmidecode # RAM stuff
      powertop
      wget

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

      # Hyprland
      hyprpaper

      # Downloaders
      qbittorrent

      # WakaTime
      wakatime

      # Anki
      anki

      # Rice
      eww-wayland

    ];
  };

  programs.git = {
    enable = true;
    userName  = "adham";
    userEmail = "git@adham-omran.com";
    # signing = {
    #   signByDefault = true;
    # };
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
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "palenight";

}

# Local Variables:
# jinx-local-words: "xournalpp"
# End:
