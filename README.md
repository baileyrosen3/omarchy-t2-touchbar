# Omarchy T2 Touch Bar

A theme-aware, neo-brutalist Touch Bar for Intel T2 MacBook Pros running
Omarchy/Arch Linux and Hyprland.

This repository combines a customized `tiny-dfr` renderer with:

- automatic Omarchy foreground/background/accent colors;
- edge-to-edge, full-height icon layouts;
- a second launcher layer for frequently used apps;
- display and keyboard brightness controls;
- media, volume, screenshot, terminal, dictation, and Omarchy menu actions;
- automatic theme/font synchronization through Omarchy hooks and systemd.

The current layout was developed and tested on a MacBookPro16,1. Review device
names and app commands before using it on a different T2 model.

## Layout

The main layer contains Apps, Omarchy, Terminal, Screenshot, display and keyboard
brightness, media transport, volume, and voice recording. The Apps button opens:

Back · Zen · Herdr · Riptide · YouTube Music · YouTube · X.com · Claude ·
Codex · Gemini · Gmail · Files

Holding `Fn` exposes the standard F1–F12 layer.

## Install

First install the upstream `tiny-dfr` runtime/build dependencies listed below,
then run:

```bash
./install.sh
```

The installer builds the renderer, installs its systemd integration, adds the
user theme files and hooks, and prints the Hyprland bindings that must be copied
into `~/.config/hypr/bindings.lua`.

The brightness helper currently expects `gmux_backlight` for the display and
`:white:kbd_backlight` for the keyboard. Check yours with:

```bash
brightnessctl --list
```

## Dependencies

Rust, Cairo, libinput, FreeType, Fontconfig, librsvg 2.59+, udev, brightnessctl,
and a kernel with uinput and Apple T2 Touch Bar support.

## Credits and licenses

The renderer is based on [Asahi Linux tiny-dfr](https://github.com/AsahiLinux/tiny-dfr)
and retains its MIT/Apache licensing. Lucide icons are ISC licensed; Simple Icons
are CC0. See the included license files.
