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

# Podman Quadlet user services
mkdir -p "$HOME/.config/containers/systemd"
find "$SCRIPT_DIR/quadlet" -type f -print0 | while IFS= read -r -d '' f; do
    ln -sf "$f" "$HOME/.config/containers/systemd/$(basename "$f")"
done
