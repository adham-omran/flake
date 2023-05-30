{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;

plugins = with pkgs; [
  tmuxPlugins.better-mouse-mode
];

extraConfig = ''

set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",*256col*:Tc"
set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
set-environment -g COLORTERM "truecolor"

'';
  };
}
