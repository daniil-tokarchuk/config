# macOS configuration

Personal dotfiles and workstation setup for macOS on Apple Silicon. This repository configures Zsh, Git, SSH, Neovim, and Vim, and includes a setup script for applications and macOS preferences. The paths and commands below describe the current `mac-silicon` configuration.

## Contents

- [Files](#files)
- [Setup and personalization](#setup-and-personalization)
- [Shell aliases](#shell-aliases)
- [Shell features](#shell-features)
- [Git configuration and aliases](#git-configuration-and-aliases)
- [Vim and Neovim](#vim-and-neovim)
- [macOS preferences](#macos-preferences)
- [Operational notes](#operational-notes)

## Files

| File | Purpose | Installed location |
| --- | --- | --- |
| [setup.sh](setup.sh) | SSH bootstrap, Homebrew installation, dotfile links, applications, and macOS preferences | Run manually |
| [.zshrc](.zshrc) | Shell aliases, completion, vi editing, prompt, Git status, and Touch ID setup | `~/.zshrc` |
| [.gitconfig](.gitconfig) | Identity, SSH commit signing, Git defaults, and aliases | `~/.gitconfig` |
| [.sshconfig](.sshconfig) | Shared SSH key and macOS Keychain settings | `~/.ssh/config` |
| [nvim.lua](nvim.lua) | Neovim plugins, editor settings, and key mappings | `~/.config/nvim/init.lua` |
| [.vimrc](.vimrc) | Vim alternative with comparable settings and shortcuts | `~/.vimrc` (manual installation) |

## Setup and personalization

### Requirements and personal settings

The setup assumes macOS, Zsh, Apple Silicon Homebrew at `/opt/homebrew`, internet access, administrator access when requested, and a GitHub account with access to `daniil-tokarchuk/config`. It uses macOS utilities such as `pbcopy`, `open`, `defaults`, and Apple's SSH Keychain integration.

Review these personal values before adopting the configuration:

| Setting | Current value / location |
| --- | --- |
| Configuration directory | `~/Projects/config`, set by `CONFIG` in `.zshrc` |
| Projects directory | `~/Projects`, set by `PROJECTS` in `.zshrc` |
| DOM repositories | `~/Projects/dom-monorepo`; also hard-coded inside `gdom` |
| Git identity | `Daniil Tokarchuk`, `daniil.v.tokarchuk@gmail.com` in `.gitconfig` |
| SSH key | Private key `~/.ssh/ed`; signing public key `~/.ssh/ed.pub` |
| Key-generation email | `daniil.v.tokarchuk@gmail.com` in `setup.sh` |
| Repository source | GitHub URLs in `setup.sh`; the Zsh configuration download explicitly uses `mac-silicon` |
| Server shortcuts | Root SSH destinations for `csp`, `csd`, and `csb` in `.zshrc` |
| Application launchers | IntelliJ IDEA and Codex, referenced by their macOS application names |

### Running setup

**Setup deletes and reclones `~/Projects/config`, replaces existing dotfile destinations with symlinks, and changes system preferences. Back up local configuration and repository work first.** It is a workstation bootstrap script with no automatic backup or rollback, and no fail-fast setting.

To run a reviewed local copy, copy the script outside the configuration directory and run it from there so it does not delete its own working directory:

```zsh
# Run from this repository after reviewing setup.sh and backing up existing files.
cp setup.sh /tmp/config-setup.zsh
cd /tmp
zsh ./config-setup.zsh
```

The script performs these steps:

1. Downloads `.zshrc` from the `mac-silicon` branch and evaluates lines containing `CONFIG=` to obtain the configuration path.
2. Generates an Ed25519 SSH key at `~/.ssh/ed` with an empty passphrase, adds it to the agent using macOS Keychain integration, and appends GitHub's scanned host keys to `~/.ssh/known_hosts`.
3. Copies `~/.ssh/ed.pub` to the clipboard and pauses for a keypress while you add it to GitHub. Register it for authentication before continuing; SSH commit signing also requires the appropriate signing-key registration.
4. Runs the Homebrew installer, which can provision the command-line developer tools, then deletes the configuration directory and clones the repository over SSH. The clone uses the remote's default branch; it does not explicitly select `mac-silicon`.
5. Creates the four symlinks listed below.
6. Appends Homebrew's `shellenv` initialization to `~/.zprofile`, initializes it for the script, and adds Homebrew's binary and completion paths.
7. Removes group/other write permissions from Homebrew's Zsh share directory, initializes completion, removes `~/.zcompdump`, and removes group write permission from paths reported by `compaudit`.
8. Updates and upgrades Homebrew packages, installs the formulae and casks below, links completions, removes unused dependencies, and cleans cached downloads.
9. Applies the [macOS preferences](#macos-preferences).

| Repository source | Symlink destination |
| --- | --- |
| `~/Projects/config/.zshrc` | `~/.zshrc` |
| `~/Projects/config/.gitconfig` | `~/.gitconfig` |
| `~/Projects/config/.sshconfig` | `~/.ssh/config` |
| `~/Projects/config/nvim.lua` | `~/.config/nvim/init.lua` |

Open a new shell to load the linked Zsh configuration. Loading it can invoke `sudo` for Touch ID setup; see [operational notes](#operational-notes).

For the optional Vim configuration, back up any existing `~/.vimrc` and link it separately:

```zsh
ln -s "$HOME/Projects/config/.vimrc" "$HOME/.vimrc"
```

### Homebrew packages

| Formula | Purpose |
| --- | --- |
| `n` | Node.js version manager; setup does not install a Node.js runtime |
| `neovim` | Editor used by `v` and Git |
| `ripgrep` | Text search for Telescope live grep and Vim's `:Rg` |
| `zsh-completions` | Additional shell completions |

| Cask | Application / resource |
| --- | --- |
| `binance` | Binance desktop application |
| `bitwarden` | Password manager |
| `codex` | Codex command-line tool |
| `codex-app` | Codex desktop application used by `c` |
| `discord` | Chat and voice |
| `docker-desktop` | Docker Desktop |
| `font-ubuntu-mono-nerd-font` | Ubuntu Mono Nerd Font |
| `google-chrome` | Browser |
| `intellij-idea` | IDE used by `o` |
| `iterm2` | Terminal |
| `mysql-shell` | MySQL Shell |
| `notion` | Notes and workspace |
| `postman` | API client |
| `slack` | Team messaging |
| `spotify` | Music |
| `telegram` | Messaging |
| `tunnelbear` | VPN |
| `vlc` | Media player |

Setup declares both the Codex command-line tool and desktop application. The font is installed, but the script does not select it in a terminal profile. The package names above are the script's declared installation list.

## Shell aliases

Defined in [.zshrc](.zshrc). Arguments can be appended to simple aliases, for example `dr container-name` or `g s`.

### Navigation and everyday commands

| Alias | Expansion / behavior |
| --- | --- |
| `cd.` | `cd ~/Projects/config` |
| `cdp` | `cd ~/Projects` |
| `cdm` | `cd ~/Projects/dom-monorepo` |
| `..` | Move up one directory |
| `...` | Move up two directories |
| `....` | Move up three directories |
| `.....` | Move up four directories |
| `......` | Move up five directories |
| `g` | `git` |
| `v` | `nvim` |
| `q` | `exit` |
| `l` | `ls -AlFh`: long listing, hidden entries except `.` and `..`, type indicators, human-readable sizes |
| `o` | `open -a 'IntelliJ IDEA' .`: open the current directory in IntelliJ IDEA |
| `c` | `open -a 'Codex' .`: open the current directory in Codex |

The shell command `c` opens Codex. `git c` (or `g c`) creates a signed Git commit.

### Editing configuration and maintenance

| Alias | Expansion / behavior |
| --- | --- |
| `uz` | Edit `~/.zshrc` in Neovim, then source it if the editor exits successfully |
| `uv` | Edit `~/.config/nvim/init.lua` in Neovim |
| `ug` | Edit `~/.gitconfig` in Neovim |
| `us` | Edit `~/Projects/config/setup.sh` in Neovim |
| `u` | `brew update && brew upgrade --greedy && brew autoremove && brew cleanup --prune=all` |

`u` upgrades packages, including casks selected by `--greedy`, removes unused dependencies, and clears cached downloads. It affects the Homebrew installation as a whole.

### Docker and Compose

| Alias | Expansion / behavior |
| --- | --- |
| `d` | `docker` |
| `ds` | `docker ps -a`, formatted as Names / Image / Status |
| `dr` | `docker restart`; append container names or IDs |
| `dv` | `docker volume ls` |
| `dsp` | `docker system prune` |
| `dcu` | `docker compose -f compose.yaml up -d --build --pull always` |
| `dcd` | `docker compose down` |
| `dcs` | `docker compose ps -a`, formatted as Name / Image / Status |

`dcu` explicitly uses `compose.yaml`, rebuilds services, always pulls images, and starts detached. `dcd` and `dcs` use Compose's normal configuration discovery. Docker Desktop must be running. `dsp` removes unused Docker resources; no volume-pruning flag is included.

### SSH destinations

| Alias | Command |
| --- | --- |
| `csp` | `ssh root@65.108.196.190` |
| `csd` | `ssh root@65.109.146.239` |
| `csb` | `ssh root@176.9.82.217` |

[.sshconfig](.sshconfig) applies `UseKeychain yes`, `AddKeysToAgent yes`, and `IdentityFile ~/.ssh/ed` to every host (`Host *`). These shortcuts assume the key has access to the corresponding root account.

## Shell features

### Run Git across DOM repositories

```zsh
gdom <subcommand> [args...]

# Examples: inspect each matching repository.
gdom status -sb
gdom log -1 --oneline
```

`gdom` visits immediate directories matching `~/Projects/dom-monorepo/dom-*`, excluding `dom-database` and `dom-config`. It prints each directory name and runs `git "$@"` in a subshell, preserving the caller's working directory. Git aliases work here too, for example `gdom s -sb`.

With no arguments it prints usage and returns `1`. It does not verify that each directory is a Git repository or aggregate failures, and a failure in one iteration does not stop later iterations. With Zsh's default unmatched-glob behavior, no matching directories can produce a glob error. Mutating Git subcommands affect every included repository.

### Environment, completion, and editing

| Feature | Configuration |
| --- | --- |
| Project roots | `CONFIG=~/Projects/config`, `PROJECTS=~/Projects` |
| Node executables | `N_PREFIX=~/.n`; `~/.n/bin` is appended to `PATH` |
| Editor variable | `EDITOR="o"`, naming the IntelliJ launcher alias; Git separately uses `nvim` |
| History | `HISTSIZE=1000000`; this file does not configure `HISTFILE` or `SAVEHIST` for persistence |
| Hidden files | `globdots` includes dotfiles in glob matches |
| Bell | `NO_BEEP` disables the shell beep |
| Completions | `/opt/homebrew/share/zsh-completions` in `FPATH`; `compinit -C` initializes completion using its cached setup |
| Completion selection | Menu selection enabled; `h` / `j` / `k` / `l` move left / down / up / right |
| Command-line editing | `bindkey -v` enables vi mode; Escape enters command mode |
| Escape timing | `KEYTIMEOUT=1` sets the key-sequence timeout to one hundredth of a second |
| Cursor | `zle-line-init` requests a steady bar; `zle-keymap-select` requests a steady bar in `main` and a steady block in other keymaps, in terminals supporting these escape sequences |

`EDITOR` is assigned a shell alias rather than an executable path, and these variables are not explicitly exported by this file. Programs launching an external editor do not necessarily resolve `o` as an interactive alias. Likewise, a tool requiring `N_PREFIX` in its environment may need it exported separately.

### Prompt and Git status

The left prompt is `%~ > `: current directory with home abbreviated as `~`, followed by `>`. Before each prompt, the `git-status-cli` function reads `git status -sb` and the latest stash entry. Outside a Git working tree it clears the right prompt.

| Right-prompt marker | Meaning checked by the function |
| --- | --- |
| `λ:<branch>` | Branch/status-header text extracted from the short Git status header |
| `<` | Branch is behind its upstream |
| `>` | Branch is ahead of its upstream |
| `a` | Added files (`A`) |
| `m` | Modified files or type changes (`M` / `T`) |
| `d` | Deleted files (`D`) |
| `r` | Renamed files (`R`) |
| `=` | Both-modified merge conflicts (`UU`) |
| `u` | Untracked files (`??`) |
| `s` | A stash entry exists |

This is a compact parser rather than a complete Git status summary: the header extraction stops at the first dot, and the conflict marker checks `UU` specifically. Use `g s` for full status details.

### Touch ID for sudo

On loading `.zshrc`, the configuration searches `/etc/pam.d/sudo` for `pam_tid.so`. If the string is absent, it runs `sudo sed` to insert `auth sufficient pam_tid.so` after the first line. This can prompt for a password and changes sudo authentication on the machine. The check looks for the string; it does not validate whether an existing matching line is active.

## Git configuration and aliases

Defined in [.gitconfig](.gitconfig). Prefix the aliases below with `git` or `g`.

### Defaults

| Setting | Behavior |
| --- | --- |
| Identity | `Daniil Tokarchuk <daniil.v.tokarchuk@gmail.com>` |
| Editor | `nvim` |
| Line endings | `core.autocrlf=input`: normalize CRLF to LF when adding text, without converting LF to CRLF on checkout |
| Diff and merge tools | `nvimdiff` |
| Merge backups | `mergetool.keepBackup=false` |
| Signing | SSH format, public key `~/.ssh/ed.pub`, `commit.gpgsign=true` |
| Fetch | Prune stale remote-tracking branches |
| Push | Automatically set an upstream on a default push where applicable |
| Pull | Rebase rather than merge |
| New repositories | Default branch `main` |

Signed commits need the corresponding private key available to Git/SSH. The `c` alias also explicitly requests signing with `-S`.

### Basic commands, branches, and submodules

| Alias | Expansion |
| --- | --- |
| `h` | `help` |
| `d` | `diff` |
| `f` | `fetch` |
| `b` | `branch` |
| `s` | `status` |
| `i` | `init` |
| `l` | `log` |
| `cl` | `clone` |
| `ch` | `cherry-pick` |
| `co` | `checkout` |
| `cob` | `checkout -b` |
| `cos` | `checkout staging` |
| `com` | `checkout main` |
| `cod` | `checkout dev` |
| `sm` | `submodule` |
| `smfe` | `submodule foreach` |
| `smu` | `submodule update --remote --merge` |
| `rsu` | `remote set-url origin` |

`smu` updates submodules from their configured remote branches and merges into their current branches; it is different from simply checking out the superproject's recorded commits.

```zsh
g s -sb
g cob feature-name
g smfe 'git status -sb'
g rsu git@github.com:owner/repository.git
```

### Staging, commits, and pushing

| Alias | Expansion / sequence |
| --- | --- |
| `a` | `add` |
| `ap` | `add -p` |
| `c` | `commit -S` |
| `ca` | `commit -S --amend` |
| `can` | `commit -S --amend --no-edit` |
| `canpf` | `git can && git pf`: amend without editing the message, then push with lease |
| `capf` | `git ca && git pf`: amend with message editing, then push with lease |
| `cp` | `git c && git p`: signed commit, then push |
| `ac` | `git a . && git c`: stage, then signed commit |
| `aca` | `git a . && git ca`: stage, then amend |
| `acan` | `git a . && git can`: stage, then amend without editing the message |
| `acanpf` | `git a . && git canpf`: stage, amend without editing, then push with lease |
| `acapf` | `git a . && git capf`: stage, amend with message editing, then push with lease |
| `acp` | `git a . && git cp`: stage, signed commit, then push |
| `p` | `push` |
| `pn` | `push --no-verify` |
| `pf` | `push --force-with-lease` |
| `pfn` | `push --force-with-lease --no-verify` |
| `pl` | `pull` (rebases under this configuration) |

The multi-command aliases use Git's shell-alias mechanism (`!`), which runs from the repository's top-level directory. Their `git a .` therefore stages changes across the repository even when invoked from a subdirectory. Additional arguments are not explicitly forwarded to a chosen inner command; use simple aliases when supplying commit options, for example:

```zsh
g ap
g c -m "Describe the change"
g p
```

Amending rewrites the latest commit. `--force-with-lease` can rewrite remote history, while checking the expected remote state. `--no-verify` on push bypasses the pre-push hook.

### Branch synchronization helpers

```zsh
g rpf <target> <base>
```

`rpf` checks out and pulls `<base>`, then checks out and pulls `<target>`, rebases the target onto the base, and pushes the target with `--force-with-lease --no-verify`. Both pulls follow the configured rebase policy. The helper ends on the target branch when successful.

| Alias | Invocation | Branch rebased and pushed | Rebased onto |
| --- | --- | --- | --- |
| `rms` | `rpf main staging` | `main` | `staging` |
| `rds` | `rpf dev staging` | `dev` | `staging` |
| `rsd` | `rpf staging dev` | `staging` | `dev` |
| `rdm` | `rpf dev main` | `dev` | `main` |
| `rsm` | `rpf staging main` | `staging` | `main` |
| `rmd` | `rpf main dev` | `main` | `dev` |

These helpers assume the named branches and usable remotes/upstreams exist. They rewrite history and bypass the pre-push hook. The base-update sequence and target-update sequence are separated by a semicolon: a failed base checkout/pull does not prevent the target sequence from being attempted. The helper does not restore the original branch or roll back partial work.

### Rebase, restore, stash, and cleanup

| Alias | Expansion / behavior |
| --- | --- |
| `ri` | `rebase -i` |
| `rim` | `rebase -i main` |
| `ris` | `rebase -i staging` |
| `rid` | `rebase -i dev` |
| `ra` | `rebase --abort` |
| `rc` | `rebase --continue` |
| `r` | `restore`: restore working-tree paths from the index by default |
| `rs` | `restore --staged`: unstage paths |
| `rss` | `reset --soft`: move HEAD while keeping index and working-tree contents |
| `rev` | `revert`: create a commit reversing another commit |
| `sk` | `stash -u`: stash tracked changes and untracked files, excluding ignored files |
| `sp` | `stash pop` |
| `sd` | `stash drop` |
| `sl` | `stash list` |
| `uiau` | `update-index --assume-unchanged` |
| `uinau` | `update-index --no-assume-unchanged` |
| `xu` | `clean -df`: delete untracked files and directories, excluding ignored files |
| `xi` | `clean -dfX`: delete only ignored files and directories |
| `xui` | `clean -dfx`: delete untracked and ignored files and directories |

Append paths or revisions as required, for example `g rs file.txt`, `g rss HEAD~1`, or `g uinau path/to/file`. Assume-unchanged is an index performance hint, not a reliable way to maintain private configuration changes.

`restore` can discard unstaged edits, `stash drop` removes a stash entry, and the `clean` aliases delete files outside Git's tracked history. Preview cleanup with the corresponding dry run, such as `git clean -nd`, `git clean -ndX`, or `git clean -ndx`.

## Vim and Neovim

[nvim.lua](nvim.lua) is installed automatically by setup. [.vimrc](.vimrc) is an optional Vim alternative.

### Shared settings and shortcuts

Both editors use spaces with a two-space tab/indent width, relative line numbers with an absolute current-line number, system clipboard integration (`unnamedplus`, subject to editor/provider support), and persistent undo. `Ctrl+D` / `Ctrl+U` scroll by ten lines through `scroll=10`.

| Shortcut | Mode | Neovim | Vim |
| --- | --- | --- | --- |
| `?` | Normal | Clear search highlighting | Clear search highlighting |
| `U` (`Shift+U`) | Normal | Redo (`Ctrl+R`) | Redo (`Ctrl+R`) |
| `t` | Normal | Toggle NvimTree | Toggle NERDTree |
| `c` | Normal | Toggle a line comment on the current line | Toggle a line comment via `gcc` |
| `c` | Visual | Toggle line comments on the selection | Toggle comments via `gc` |
| `Space`, then `f` | Normal | Telescope `live_grep` | FZF `:Rg` text search |
| `Space`, then `g` | Normal | Telescope `find_files` | FZF `:Files` file search |

These are overrides: `?` replaces backward search, `U` replaces line undo, `t` replaces the normal till-character motion, and `c` replaces the usual change operator in the mapped modes.

| Editor | Undo storage |
| --- | --- |
| Neovim | `vim.fn.stdpath("cache") .. "/undo"`; the configuration does not explicitly create this directory |
| Vim | `~/.vim/undo`; created if missing |

### Neovim plugins

On startup, the configuration clones `folke/lazy.nvim` into `stdpath("data")/lazy/lazy.nvim` if absent and adds it to the runtime path. This bootstrap requires Git and network access. Plugin setup uses the following declarations:

| Plugin | Purpose / configuration |
| --- | --- |
| `nvim-tree/nvim-tree.lua` | File tree; Git integration disabled |
| `nvim-tree/nvim-web-devicons` | File-tree icons; a suitable icon font helps display them |
| `numToStr/Comment.nvim` | Comment toggling with default plugin setup |
| `nvim-telescope/telescope.nvim` | File and text search; ignores patterns `node_modules` and `.git` |
| `nvim-lua/plenary.nvim` | Telescope dependency |

Telescope live grep uses `ripgrep`, included in setup. Open `:Lazy` to inspect/manage the declared plugins.

When `vim.g.vscode` is set, plugin setup and the tree/comment/Telescope mappings are skipped. Basic editor settings and the `?` / `U` mappings remain active. The lazy.nvim clone/runtime-path bootstrap is outside that guard and still runs.

### Vim plugins

If `~/.vim/autoload/plug.vim` is absent, `.vimrc` downloads vim-plug and schedules `PlugInstall --sync` followed by reloading the configuration on `VimEnter`. Plugins are stored in `~/.vim/plugged`.

| Plugin | Purpose |
| --- | --- |
| `preservim/nerdtree` | File tree |
| `tpope/vim-commentary` | Comment toggling |
| `junegunn/fzf` | Fuzzy finder, with an `fzf#install()` installation hook |
| `junegunn/fzf.vim` | Vim search commands such as `:Files` and `:Rg` |

`:Rg` requires `ripgrep`; FZF commands need the fzf executable, supplied through the plugin's installation hook or a separate installation. Setup does not declare a Homebrew `fzf` formula. If vim-plug already exists but the plugins are missing, run `:PlugInstall` manually.

## macOS preferences

[setup.sh](setup.sh) writes these preferences after installing packages. Some applications or system components may need to be reopened for changes to appear.

| Preference | Domain / key | Value / intended effect |
| --- | --- | --- |
| Chrome swipe navigation | `com.google.Chrome` / `AppleEnableSwipeNavigateWithScrolls` | `false`: disable swipe back/forward navigation |
| Tap to click | `com.apple.AppleMultitouchTrackpad` / `Clicking` | `true` |
| Trackpad speed | Global / `com.apple.trackpad.scaling` | `3.0` |
| Zoom menu shortcut | `NSGlobalDomain` / `NSUserKeyEquivalents`, `Zoom` | `@$F`: `Command+Shift+F` for the menu item named `Zoom` |
| Pinned Dock apps | `com.apple.dock` / `persistent-apps` | Empty array: clear pinned applications |
| Other Dock items | `com.apple.dock` / `persistent-others` | Empty array: clear pinned folders/stacks and other items |
| Dock visibility | `com.apple.dock` / `autohide` | `true`: automatically hide the Dock |
| Recent Dock apps | `com.apple.dock` / `show-recents` | `false` |
| Bottom-right hot corner | `com.apple.dock` / `wvous-br-corner` | `0`: disable its action |

The Zoom shortcut targets a macOS menu item by name, not the Zoom conferencing application.

## Operational notes

- **Setup is destructive and not idempotent.** It removes the config checkout, replaces dotfile links without backups, can encounter an existing SSH key, appends to `.zprofile` and `known_hosts`, upgrades installed packages, and resets Dock contents. Without fail-fast handling, later steps may still run after an earlier failure.
- **Loading the shell can change authentication.** Both a new shell and `uz` execute the Touch ID check and may invoke privileged changes to `/etc/pam.d/sudo`.
- **Git shortcuts can change shared history or remove local data.** Check the commit/amend/push, synchronization, restore, stash, and clean tables before using unfamiliar abbreviations.
- **Bulk commands apply broadly.** `gdom` forwards the same Git command to every included DOM directory; the `ac*` Git shell aliases stage from the repository root.
- **Some dependencies need separate action.** Select a Node.js version with `n` when needed, ensure Docker Desktop is running for Docker commands, and install the optional Vim configuration separately.
- **The configuration is personal and macOS-specific.** Review identity, key paths, root SSH destinations, repository URLs, and application names before using it on another machine. No private SSH keys are included in the repository.
