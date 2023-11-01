{config, pkgs, lib, ...}:
let
  archive-app="org.kde.ark.desktop";
  pdf-app="sioyek.desktop";
  img-app="org.kde.gwenview.desktop";
  browser-app="firefox.desktop";
  video-app="vlc.desktop";
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
      imagemagick
      python311Packages.pyclip
      firejail
      lilypond
      arduino
      ncdu
      rclone
      mysql80
      pscale
      awscli2
      
      scream
      zoom-us
      
      isync
      msmtp
      afew
      notmuch
      
      mpc-cli
      
      ripgrep
      texlive.combined.scheme-full
      
      poppler_utils
      
      warpd
      distrobox
      
      aspell
      aspellDicts.en
      aspellDicts.ar
      
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
      zeal
      freetube
      gimp-with-plugins
      qbittorrent
      chromedriver
      zotero
      libreoffice-qt
      reaper
      nyxt
      anki-bin
      frescobaldi
      sonobus
      vlc
      jdk17
      nodejs_20
      cool-retro-term
      
      xournalpp
      
      google-chrome
      geckodriver
      
      libsForQt5.gwenview
      krusader
      
      obs-studio
      poedit
      foliate
      
      zulip
      discord
      telegram-desktop
      spotify
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
      cliphist
      foot
      sway-contrib.grimshot
      fuzzel
      wf-recorder
      (waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
    ];
  };
  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
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
  programs.hexchat = {
    enable = true;
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
  programs.sioyek = {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
      "shared_database_path" = "/home/adham/docs/sioyek-shared/shared.db";
    };
  };

  xdg.mimeApps = {
    enable = false;
    associations.added = {
  
    };
    defaultApplications = {
      "application/zip"=["${archive-app}"];
      "video/webm"=["${video-app}"];
      "video/mp4"=["${video-app}"];
  
      "x-scheme-handler/http"=["${browser-app}"];
      "x-scheme-handler/https"=["${browser-app}"];
      "x-scheme-handler/chrome"=["${browser-app}"];
      "text/html"=["${browser-app}"];
      "application/x-extension-htm"=["${browser-app}"];
      "application/x-extension-html"=["${browser-app}"];
      "application/x-extension-shtml"=["${browser-app}"];
      "application/xhtml+xml"=["${browser-app}"];
      "application/x-extension-xhtml"=["${browser-app}"];
      "application/x-extension-xht"=["${browser-app}"];
  
      "application/pdf" = ["${pdf-app}"];
      "image/bmp"= ["${img-app}"];
      "image/gif"=["${img-app}"];
      "image/jpeg"=["${img-app}"];
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
