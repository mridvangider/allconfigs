#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
ln -sf "$SCRIPT_DIR/.bashrc.d" "$HOME/.bashrc.d"
ln -sf "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
