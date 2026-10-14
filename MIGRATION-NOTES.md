# Migration Notes: `vim.pack` and blink.cmp

The migration is done: your config now uses `vim.pack` and blink.cmp, built on the latest upstream kickstart. Neovim starts with no errors and the formatting check passes. Nothing is committed yet.

## Broken C toolchain (resolved)

> **Resolved:** `sudo xcode-select --switch /Library/Developer/CommandLineTools` was run, and Neovim builds parsers again without any workaround.

One problem outside the config needs your attention: your Mac's C compiler can't link programs right now. Your selected Xcode is 26.0.1, which is older than the macOS 27 SDK it's being paired with.

I built the parsers, fzf and LuaSnip's regex library by pointing just those commands at the Command Line Tools. But any future build Neovim starts will fail until this is fixed:

- a parser for a new file type such as Python or YAML
- a rebuild after a plugin update

Either of these fixes it:

- update Xcode, or
- run `sudo xcode-select --switch /Library/Developer/CommandLineTools`.

## What I tested

These checks ran in headless Neovim:

- **TypeScript and Vue:** `vtsls`, plus `vue_ls` in Vue files, attach, with Treesitter highlighting and all your LSP keymaps, including `<leader>co`.
- **Lua:** `lua_ls` and `stylua` attach.
- **Snippets:** your snippets load, and `tstgrp` expands correctly.
- **Completion:** blink loads and its capabilities reach the language servers.
- **Builds:** the fzf and LuaSnip builds work, and all 17 parsers are installed, including TypeScript, TSX, JavaScript, Vue, CSS and JSON.

I couldn't check that the completion menu actually pops up as you type. Headless Neovim doesn't run the interactive typing loop, and my two attempts hung, so I stopped them. Please try it in a TypeScript or Vue project.

## What's in the repo changes

- **`init.lua`:** rebuilt from upstream's version. Your customizations are re-applied:
  - catppuccin, relative numbers, spellcheck and the Nerd Font setting
  - your LSP keymaps exactly as before
  - the `vtsls` + `vue_ls` setup
  - your Conform formatters and format-on-save
  - your which-key groups
  - autopairs and neo-tree
- **Fixes from the comparison:** Treesitter's `main` branch, inline diagnostics, the `mini.ai` key change, `lsp_format`, gitsigns keymaps and `mini.icons`.
- **Plugin management commands:** `:PackUpdate`, `:PackStatus` and `:PackClean` are defined in `init.lua`'s plugin-manager section. See [Managing plugins](#managing-plugins) below.
- **Optional modules:** `lua/kickstart/plugins/*`, `lua/custom/plugins/init.lua`, `health.lua` and `.stylua.toml` are now upstream's `vim.pack` versions. The old `gitsigns.lua` is deleted.
- **Lockfile:** `nvim-pack-lock.json` is new and will be tracked in git, as upstream recommends. `lazy-lock.json` is deleted.
- **Docs:** `AGENTS.md` is rewritten for the new layout, and the README install steps now include `tree-sitter-cli` and a note on the Xcode problem.

## Changes outside the repo

- I installed `tree-sitter-cli` with Homebrew.
- Plugins are downloaded to `~/.local/share/nvim/site/pack/core/opt/` and parsers to `~/.local/share/nvim/site/parser/`.
- I removed three broken links in `site/queries` that pointed into the old `lazy` folder.

## What will feel different

- Diagnostic text now shows at the end of the line, and `[d` / `]d` open the full message.
- The which-key popup appears immediately.
- `mini.ai`'s "next" text objects are now `aa` / `ii` instead of `an` / `in`.
- **New gitsigns keys:**
  - `]c` / `[c` jump between changes
  - `<leader>h…` keys stage, reset, preview and blame changes
  - `<leader>tb` and `<leader>tw` toggle line blame and word-level diffs
- **Telescope:** `<leader>sc` searches commands.
- **Completion:**
  - `<C-y>` accepts
  - `<C-l>` / `<C-h>` still jump through snippets, and `<Tab>` / `<S-Tab>` also work
  - `<C-e>` closes the menu
  - `<C-k>` toggles signature help
- **Quitting with unsaved changes:** `:q` asks whether to save instead of refusing.
- **Removed plugins:** `lazydev` is gone. Lua completion for Neovim's API now comes from `lua_ls` directly, which can be slower the first time you open this config.
- **Startup:** every plugin now loads when Neovim starts, since `vim.pack` has no lazy loading.

## Managing plugins

`vim.pack` has no `:Lazy`-style dashboard. These commands replace it:

| Command | What it does | Replaces |
|---|---|---|
| `:PackUpdate` | Downloads updates and opens a review tab. Type `:write` to apply them or `:quit` to discard them. Pass plugin names (with tab-completion) to update only those, for example `:PackUpdate telescope.nvim`. | `:Lazy update` / `:Lazy sync` |
| `:PackStatus` | Shows installed plugins and their versions without downloading anything. Move between plugins with `[[` and `]]`. | `:Lazy` |
| `:PackClean` | Lists plugins that are on disk but no longer added in the config, and deletes them after you confirm. | `:Lazy clean` |

- **New plugins:** add a `vim.pack.add` line and restart. Neovim installs it after you confirm.
- **Removing a plugin:** delete its `vim.pack.add` line first (otherwise it is reinstalled), restart, then run `:PackClean`.
- **After an update:** run `:restart` to load the new code, and commit `nvim-pack-lock.json`.
- **Rolling back an update:** run `git checkout HEAD -- nvim-pack-lock.json`, then `:restart`, then `:lua vim.pack.update(nil, { offline = true, target = 'lockfile' })`.
- **Not covered by these commands:** language servers and tools are still managed in `:Mason`. Treesitter parsers rebuild automatically when nvim-treesitter updates; `:TSUpdate` also works.

## What you need to do

1. ~~Fix the Xcode toolchain as described above.~~ Done: switched to the Command Line Tools with `xcode-select`.
2. Open a TypeScript or Vue project and check that completion pops up as you type.
3. Once you're happy, delete `~/.local/share/nvim/lazy`; the new config no longer uses it. `~/.local/share/nvim/gp`, left over from gp.nvim, can go too.
4. Commit the changes, including `nvim-pack-lock.json`.
