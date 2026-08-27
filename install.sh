#!/bin/bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
touchbar_dir="$HOME/.config/omarchy/touchbar"

cargo build --release --manifest-path "$repo_dir/Cargo.toml"

install -d "$touchbar_dir" "$HOME/.local/bin"
cp -a "$repo_dir/omarchy/config.template.toml" "$repo_dir/omarchy/sync-theme" \
  "$repo_dir/omarchy/lucide" "$repo_dir/omarchy/simple-icons" "$touchbar_dir/"
sed -i "s|@HOME@|$HOME|g" "$touchbar_dir/sync-theme"
sed -i "s|@UID@|$(id -u)|g" "$touchbar_dir/config.template.toml"
install -m 0755 "$repo_dir/omarchy/bin/touchbar-brightness" "$HOME/.local/bin/"
install -m 0755 "$repo_dir/omarchy/bin/touchbar-media-status" "$HOME/.local/bin/"
install -m 0755 "$repo_dir/omarchy/bin/touchbar-voice-status" "$HOME/.local/bin/"

install -d "$HOME/.config/systemd/user"
install -m 0644 "$repo_dir/omarchy/systemd/user/omarchy-touchbar-media-status.service" \
  "$HOME/.config/systemd/user/"
install -m 0644 "$repo_dir/omarchy/systemd/user/omarchy-touchbar-voice-status.service" \
  "$HOME/.config/systemd/user/"

install -d "$HOME/.config/omarchy/hooks/theme-set.d" "$HOME/.config/omarchy/hooks/font-set.d"
install -m 0755 "$repo_dir/omarchy/hooks/theme-set.d/touchbar-theme-sync.sh" \
  "$HOME/.config/omarchy/hooks/theme-set.d/"
install -m 0755 "$repo_dir/omarchy/hooks/font-set.d/touchbar-font-sync.sh" \
  "$HOME/.config/omarchy/hooks/font-set.d/"
sed -i "s|@HOME@|$HOME|g" \
  "$HOME/.config/omarchy/hooks/theme-set.d/touchbar-theme-sync.sh" \
  "$HOME/.config/omarchy/hooks/font-set.d/touchbar-font-sync.sh"

sudo install -m 0755 "$repo_dir/target/release/tiny-dfr" /usr/local/bin/tiny-dfr-omarchy
sudo install -m 0755 "$repo_dir/omarchy/bin/omarchy-touchbar-sync" /usr/local/libexec/
sudo install -m 0644 "$repo_dir/omarchy/systemd/omarchy-touchbar-sync.service" /etc/systemd/system/
sudo install -m 0644 "$repo_dir/omarchy/systemd/omarchy-touchbar-sync.path" /etc/systemd/system/
sudo install -d /etc/systemd/system/tiny-dfr.service.d
sudo install -m 0644 "$repo_dir/omarchy/systemd/omarchy-theme.conf" /etc/systemd/system/tiny-dfr.service.d/

sudo sed -i "s|@HOME@|$HOME|" /etc/systemd/system/omarchy-touchbar-sync.path
sudo sed -i "/\[Service\]/a Environment=TOUCHBAR_USER_HOME=$HOME" /etc/systemd/system/omarchy-touchbar-sync.service

"$touchbar_dir/sync-theme"
sudo systemctl daemon-reload
sudo systemctl enable --now omarchy-touchbar-sync.path tiny-dfr.service
sudo systemctl start omarchy-touchbar-sync.service
systemctl --user daemon-reload
systemctl --user enable --now omarchy-touchbar-media-status.service
systemctl --user enable --now omarchy-touchbar-voice-status.service

printf '\nInstall complete. Add the bindings from:\n  %s\n' "$repo_dir/omarchy/bindings.lua"
