# minfiles

Minimal, opinionated dotfiles for **servers, VMs, LXCs, and bare metal**, with a clear split between:

* **`minimal`** → ultra-safe, zero-dependency config
* **`nice`** → same base, plus Vim plugins and quality-of-life features

Designed to be:

* predictable
* easy to audit
* safe to deploy over SSH / cloud-init / CI
* usable on Linux, BSD, macOS, Proxmox, Alpine, etc.

---

## Repository Structure

```text
minfiles/
├── profiles/
│   ├── minimal/
│   │   ├── .bashrc
│   │   └── .vimrc
│   └── nice/
│       ├── .bashrc
│       └── .vimrc
├── setup/
│   ├── minimal.sh
│   └── nice.sh
└── README.md
```

---

## Profiles

### 🧱 `minimal` profile (recommended default for servers)

**What it installs**

* `~/.bashrc`
* `~/.vimrc`

**Characteristics**

* No plugins
* No external dependencies
* No Git required
* Fast startup
* Safe for rescue shells, initramfs, minimal containers

**Use cases**

* Production servers
* Proxmox hosts
* Alpine / BusyBox systems
* Emergency SSH sessions
* Systems you don’t fully control

**Install**

```bash
cd setup
./minimal.sh
```

Optional: copy instead of symlink

```bash
COPY=1 ./minimal.sh
```

---

### ✨ `nice` profile (servers + comfort)

Everything from **minimal**, plus:

**Vim plugins (native `pack/*`)**

* `tokyonight` – colorscheme
* `vim-fugitive` – Git integration
* `vim-airline` + themes – status line
* `auto-pairs` – auto-close brackets
* `fzf.vim` – fuzzy finding (fzf binary optional)

**Characteristics**

* Still Vim-only (no Neovim requirement)
* No plugin manager
* Deterministic installs
* Works over SSH and in CI
* Plugins are optional but **enabled by default**

**Install**

```bash
cd setup
./nice.sh
```

---

## Vim Plugin Install Behavior (nice profile)

| Scenario                   | Result                    |
| -------------------------- | ------------------------- |
| `./nice.sh` (TTY)          | Prompt (default: **YES**) |
| `./nice.sh` (non-TTY / CI) | **Install plugins**       |
| `PLUGINS=1 ./nice.sh`      | Force install             |
| `PLUGINS=0 ./nice.sh`      | Skip plugins              |

Plugins are installed to:

```text
~/.vim/pack/minfiles/start/
```

This uses **Vim’s native package system** — no Pathogen, Plug, or runtime hacks.

---

## Symlink vs Copy

By default, files are **symlinked**:

```text
~/.bashrc → minfiles/profiles/*/.bashrc
~/.vimrc  → minfiles/profiles/*/.vimrc
```

To **copy files instead** (recommended for immutable servers):

```bash
COPY=1 ./minimal.sh
COPY=1 ./nice.sh
```

---

## Requirements

| Profile             | Requirements |
| ------------------- | ------------ |
| minimal             | POSIX shell  |
| nice (no plugins)   | POSIX shell  |
| nice (with plugins) | `git`        |

Optional (nice profile only):

* `fzf` binary (for best experience with `fzf.vim`)

---

## Philosophy

* **Servers first**, not dotfile vanity
* One Vim config that works everywhere
* No plugin manager magic
* Easy to read, easy to delete
* You should be able to `scp` this repo and trust it

If you want:

* Neovim
* LSP
* Treesitter
* Language tooling

Those belong in a **different repo**.

---

## Quick Examples

### Minimal server bootstrap

```bash
git clone https://github.com/y37y/minfiles.git
cd minfiles/setup
./minimal.sh
```

### “Nice” admin box

```bash
git clone https://github.com/y37y/minfiles.git
cd minfiles/setup
./nice.sh
```

### Cloud-init / non-interactive

```bash
PLUGINS=1 COPY=1 ./nice.sh
```
