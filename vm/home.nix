{pkgs, ...}:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      nil
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
      graalvm-ce
      ardour
      multimarkdown
      activitywatch
      imagemagick
      python311Packages.pyclip
      firejail
      lilypond
      ncdu
      rclone
      mysql80
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
      btop
      fd
      dmidecode
      powertop
      wget
      brightnessctl
      pavucontrol
      pfetch
      pass
      element-desktop-wayland
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
      telegram-desktop
      spotify
      networkmanagerapplet
      cliphist
      foot
      fuzzel
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
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
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
}
