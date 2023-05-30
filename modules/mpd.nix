{...}:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/adham/music";
    extraConfig = ''

audio_output {
  type "pipewire"
  name "My PipeWire Output"
}

'';

network.listenAddress = "any";
startWhenNeeded = true;
};

services.mpd.user = "userRunningPipeWire";
systemd.services.mpd.environment = {
  XDG_RUNTIME_DIR = "/run/user/1000";
};
}
