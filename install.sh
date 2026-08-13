#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
ln -sfn "$SCRIPT_DIR/.bashrc.d" "$HOME/.bashrc.d"
mkdir -p "$HOME/.config"
ln -sfn "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Alacritty
mkdir -p "$HOME/.config/alacritty"
ln -sf "$SCRIPT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Homepage dashboard config
ln -sfn "$SCRIPT_DIR/homepage" "$HOME/.config/homepage"

# Caddy reverse proxy config
ln -sfn "$SCRIPT_DIR/caddy" "$HOME/.config/caddy"

# Podman Quadlet user services
mkdir -p "$HOME/.config/containers/systemd"
# Prune stale symlinks (e.g. after a quadlet rename) whose target no longer
# exists, so they don't linger as broken systemd units.
find "$HOME/.config/containers/systemd" -maxdepth 1 -type l -print0 | while IFS= read -r -d '' l; do
    target="$(readlink -f "$l")"
    case "$target" in
        "$SCRIPT_DIR/quadlet"/*) [ -e "$target" ] || rm -f "$l" ;;
    esac
done
find "$SCRIPT_DIR/quadlet" -type f -print0 | while IFS= read -r -d '' f; do
    ln -sf "$f" "$HOME/.config/containers/systemd/$(basename "$f")"
done
