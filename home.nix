{config, pkgs, lib, ...}:
let
  pdf-app="org.pwmt.zathura.desktop";
  img-app="feh.desktop";
in
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
      babashka
      leiningen
      clojure-lsp
      texlive.combined.scheme-full
      eww
      
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
      mpc-cli
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
  services.mpd = {
    enable = true;
    musicDirectory = "/home/adham/music";
    network.port = 9900;
    extraConfig = ''
    audio_output {
      type "pipewire"
      name "My PipeWire Output"
    }
    '';
  
    network.listenAddress = "any";
    network.startWhenNeeded = true;
    };
  services.mpdris2 = {
    enable = true;
    mpd.host = "127.0.0.1";
    mpd.port = 9900;
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
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["${pdf-app}"];
    };
    defaultApplications = {
      "application/pdf" = ["${pdf-app}"];
      "image/bmp"= ["${img-app}"];
      "image/gif"=["${img-app}"];
      "image/jpg"=["${img-app}"];
      "image/pjpeg"=["${img-app}"];
      "image/png"=["${img-app}"];
      "image/tiff"=["${img-app}"];
      "image/webp"=["${img-app}"];
      "image/x-bmp"=["${img-app}"];
      "image/x-gray"=["${img-app}"];
      "image/x-icb"=["${img-app}"];
      "image/x-ico"=["${img-app}"];
      "image/x-png"=["${img-app}"];
      "image/x-portable-anymap"=["${img-app}"];
      "image/x-portable-bitmap"=["${img-app}"];
      "image/x-portable-graymap"=["${img-app}"];
      "image/x-portable-pixmap"=["${img-app}"];
      "image/x-xbitmap"=["${img-app}"];
      "image/x-xpixmap"=["${img-app}"];
      "image/x-pcx"=["${img-app}"];
      "image/svg+xml"=["${img-app}"];
      "image/svg+xml-compressed"=["${img-app}"];
      "image/vnd.wap.wbmp"=["${img-app}"];
      "image/x-icns"=["${img-app}"];
      "x-scheme-handler/element"=["element-desktop.desktop"];
    };
  };
}
