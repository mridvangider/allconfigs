# AGENTS.md

Dotfiles / config sources for a single user (rootless podman quadlets, Neovim, bash, tmux, alacritty). One Linux machine; no build/test tooling. Edits are safe to commit directly — don't invent codegen or CI checks.

## Deploying (how these reach the machine)

- `./install.sh` symlinks everything into place: `.bashrc`→`~/.bashrc`, `.bashrc.d`→`~/.bashrc.d`, `nvim`→`~/.config/nvim`, `.tmux.conf`→`~/.tmux.conf`, `alacritty.toml`→`~/.config/alacritty/alacritty.toml`, `homepage/`→`~/.config/homepage` (the homepage quadlet bind-mounts this dir), `caddy/`→`~/.config/caddy` (the caddy quadlet bind-mounts this dir), each file in `quadlet/` and `quadlet/llama.cpp/`→`~/.config/containers/systemd/`. Re-runnable (`ln -sf`/`ln -sfn`). `install.sh` also prunes stale quadlet symlinks in `~/.config/containers/systemd/` whose target no longer exists (e.g. after a rename like `media.network`→`home.network`).
- Quadlet symlinks pickup requires a reload/start after `install.sh`: `systemctl --user daemon-reload && systemctl --user start comfyui.service` (etc). Unit sections live in file comments. GPU quadlets (`comfyui`, `llamacpp`) need nvidia-container-toolkit CDI and `# AddDevice=nvidia.com/gpu=all`.
- `llamacpp.env` is symlinked next to `llamacpp.container` only because `install.sh` flattens both into `~/.config/containers/systemd/` — `EnvironmentFile=llamacpp.env` resolves relative to that dir, not the repo. New quadlet files must not collide by basename. Model files go in `~/ai/models/...`.
- Networking: most quadlets set `Network=home.network` (`quadlet/home.network`, unit `home-network.service`) so they reach each other by container name (sonarr:8989, radarr:7878, prowlarr:9696, qbittorrent:8080, jellyfin:8096, open-webui:8080, comfyui:8188, llamacpp:8080, homepage:3001). This was previously `media.network`/NetworkName `media`; the old podman network object was removed after the rename. **`adguardhome` is the exception**: it stays on the default pasta network because its DNS listeners bind host IP 192.168.1.24 (an address that only exists in the shared host netns); its web admin is reached from the home network via `host.containers.internal:3002`. (`llamacpp` also publishes host port 8888 — moved off 8080 so it wouldn't clash with qbittorrent — but is on the home network and reached by name as `llamacpp:8080`.)
- **Caddy** (`quadlet/caddy.container`, `caddy/Caddyfile`) reverse-proxies the home services on `http://*.gider` (and `home.gider` → homepage) at host ports 80/443. It's on the home network and uses container-name upstreams; adguardhome (pasta) is proxied via `host.containers.internal:3002`. HTTP-only because the `.gider` names are internal; `*.gider` + `home.gider` must resolve to 192.168.1.24 (AdGuard Home DNS rewrite or /etc/hosts). Reload config: `podman exec caddy caddy reload --config /etc/caddy/Caddyfile`.

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