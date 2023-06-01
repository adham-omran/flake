{config, pkgs, lib, ...}:
{
  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
      sunshine
      moonlight-qt
      barrier

      mpv
      ffmpeg
      qpwgraph
      playerctl
      ncmpcpp

      clojure
      leiningen
      clojure-lsp

      texlive.combined.scheme-full
      
      poppler_utils
      
      warpd
      distrobox
      
      hunspell
      hunspellDicts.en_US
      
      yt-dlp
      gnuplot
      libnotify
      direnv
      gtk3
      graphviz
      openssl
      git
      stow
      tree
      ledger
      neofetch
      bat
      htop
      btop
      fd
      dmidecode
      powertop
      wget
      brightnessctl
      pavucontrol
      pfetch

      pass
      bitwarden

      gnome.gnome-tweaks
      
      rnote
      xournalpp
      
      google-chrome
      nyxt
      
      libsForQt5.kcalc
      libsForQt5.kclock
      
      anki
      qbittorrent
      obs-studio
      poedit
      foliate
      zathura
      cinnamon.nemo
      libreoffice-qt
      discord
      telegram-desktop
      element-desktop
      spotify
      zotero

      paper-gtk-theme
      pop-gtk-theme
      gnome.adwaita-icon-theme

      arandr
      flameshot
      scrot
      xclip
      xsel
      feh
      dunst
      rofi
      ffcast
      xss-lock
      networkmanagerapplet
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
  
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "/home/adham/music";
    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = 9900;
      execute_on_song_change = "notify-send \"Now Playing\" \"$(mpc -p 9900 --format '%title% \\n%artist% - %album%' current)\"";
    };
  };
  
  services.blueman-applet.enable = true;

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
}
