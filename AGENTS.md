# AGENTS.md

Dotfiles / config sources for a single user (rootless podman quadlets, Neovim, bash, tmux, alacritty). One Linux machine; no build/test tooling. Edits are safe to commit directly — don't invent codegen or CI checks.

## Deploying (how these reach the machine)

- `./install.sh` symlinks everything into place: `.bashrc`→`~/.bashrc`, `.bashrc.d`→`~/.bashrc.d`, `nvim`→`~/.config/nvim`, `.tmux.conf`→`~/.tmux.conf`, `alacritty.toml`→`~/.config/alacritty/alacritty.toml`, `homepage/`→`~/.config/homepage` (the homepage quadlet bind-mounts this dir), each file in `quadlet/` and `quadlet/llama.cpp/`→`~/.config/containers/systemd/`. Re-runnable (`ln -sf`/`ln -sfn`).
- Quadlet symlinks pickup requires a reload/start after `install.sh`: `systemctl --user daemon-reload && systemctl --user start comfyui.service` (etc). Unit sections live in file comments. GPU quadlets (`comfyui`, `llamacpp`) need nvidia-container-toolkit CDI and `# AddDevice=nvidia.com/gpu=all`.
- `llamacpp.env` is symlinked next to `llamacpp.container` only because `install.sh` flattens both into `~/.config/containers/systemd/` — `EnvironmentFile=llamacpp.env` resolves relative to that dir, not the repo. New quadlet files must not collide by basename. Model files go in `~/ai/models/...`.

## Shell

- `.bashrc` sources every file in `.bashrc.d/` (alphabetical); add config as new snippets there, not by editing `.bashrc` itself for anything but the sourcing loop.
- `resource` alias = `source ~/.bashrc`. `avenv` = `.venv/bin/activate`.
- `.bashrc.d/antlr.sh` references `~/dist/antlr-4.13.2-complete.jar` (external, not vendored).

## Neovim (`nvim/`)

- lazy.nvim bootstrapped from `init.lua` → `lua/config/lazy.lua`; plugins are one file each under `lua/plugins/` (imported via `{ import = "plugins" }`).
- Filetype-specific LSP setup lives in `after/lsp/<filetype>.lua` (clangd, luals, pyright, ruff). Loaded for `FileType`.
- `lazy-lock.json` at repo root gitignores any nested `lazy-lock.json` (pattern has no slash) — `nvim/lazy-lock.json` is intentionally untracked. Don't commit it.
- `lua/plugins/nvim-tree.lua.bkp` is a leftover backup; useful for reference, not a live plugin.

## tmux / alacritty

- tmux prefix is `M-a` (not C-b); vi mode Keys; copy uses `xsel -ib`.
- alacritty launches `tmux` as its shell (`[terminal] shell = "tmux"`); TERM set to `alacritty`. Font is Hack Nerd Font.