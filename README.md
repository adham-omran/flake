# NixOS Flake

This is an overview about my NixOS system.

- [ ] TODO

# Cons about NixOS

- Audio production is difficult due how Nix handles packages.
  - For example installing `airwindows-lv2` from nixpkgs does not make them
    appear when searched for by Reaper.
- JavaFX does not run.

# Home Manager

I begain using home-manager again due to its ability to support different
dotfiles *per individual machine*, this is most apperant in my Sway
configuration which needs to be different from host to vm to laptop, especialy
the displays section.

<!-- Local Variables: -->
<!-- jinx-local-words: "Cloudflare JavaFX NixOS" -->
<!-- End: -->
