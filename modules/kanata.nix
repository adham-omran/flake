{ config, pkgs, callPackage, lib, ... }:
{
  services.kanata.enable = true;
  services.kanata.package = pkgs.kanata;

  services.kanata.keyboards.usb.devices = [
    "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd" ## external keyboard
    "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
  ];

  services.kanata.keyboards.usb.config = ''
     (defvar
        tap-timeout   150
        hold-timeout  150
        tt $tap-timeout
        ht $hold-timeout
     )

     (defalias
        qwt (layer-switch qwerty)
        col (layer-switch colemak)
        a (tap-hold $tt $ht a lmet)
        r (tap-hold $tt $ht r lalt)
        s (tap-hold $tt $ht s lctl)
        t (tap-hold $tt $ht t lsft)

        n (tap-hold $tt $ht n rsft)
        e (tap-hold $tt $ht e rctl)
        i (tap-hold $tt $ht i ralt)
        o (tap-hold $tt $ht o rmet)
     )

      (defsrc
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt    rctl
      )

      (deflayer colemak
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    f    p    g    j    l    u    y    ;    [    ]    \
        caps @a   @r   @s  @t    d    h   @n   @e   @i    @o    '    ret
        lsft z    x    c    v    b    k    m    ,    .    /    rsft
        lctl lmet lalt           spc            @qwt    rctl
      )

     (deflayer qwerty
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            @col    rctl
     )


  '';
}
