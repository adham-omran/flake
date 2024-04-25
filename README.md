# NixOS Flake

An overview about my NixOS setup and use cases.

# Use Cases

## Streaming

- OBS with plugins from Flatpak appear to work better than Nixpkgs solution.

## Gaming

- Steam
    - Proton runs the games I play with no issue.

- Non-Steam
    - Minecraft runs well.

## Development

- Nix Flakes set up my development environments.

## Audio

- Reproducible Linux Audio production environment through [musnix](https://github.com/musnix/musnix).
- Most Windows VSTs work with [yabridge](https://github.com/robbert-vdh/yabridge).

# Upcoming Projects

## VFIO

### Why?

- Battlefield 3 and 4 do not work for me under Lutris.

## Audio VFIO

- Passing a USB device to do audio mixing.
    - This appears to work fine when passing a 6+ cores.
    - [ ] Test the effectiveness of CPU pinning
    - [ ] Find and test a benchmark mix

# Pain Points

- JavaFX needs an environment variable to be set per flake.

# Cons about NixOS

- Learning resources are confusing.
    - I thought learning about the `Nix` language would aid in understanding
      `Nixpkgs` but turns out there's an entire manual for those because they
      don't seem to build using `derivation`

<!-- Local Variables: -->
<!-- jinx-local-words: "Ardour Cloudflare Flatpak JavaFX Lutris Minecraft NixOS Nixpkgs VSTs" -->
<!-- End: -->
