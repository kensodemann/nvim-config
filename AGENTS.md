# Agent Instructions

## Build, test, and lint commands

- There is no repo-level build script or automated test suite in this repository. `.github/workflows/stylua.yml` is inherited from Kickstart and only runs on the upstream `nvim-lua/kickstart.nvim` repo, so no CI runs for this fork.
- `stylua` is installed by Mason and is not on the shell `PATH`. Use the full path `~/.local/share/nvim/mason/bin/stylua`.
- Check Lua formatting: `~/.local/share/nvim/mason/bin/stylua --check .`
- Format Lua files: `~/.local/share/nvim/mason/bin/stylua .`
- Check that the config loads: `nvim --headless +qa`. Any output means `init.lua` or a plugin raised an error; Neovim exits `0` even when that happens, so check the output rather than the exit code.
- `nvim --headless "+checkhealth kickstart" +qa` is not a useful check: it writes the report to a buffer that is never shown, and the report only verifies that `git`, `make`, `unzip`, and `rg` are installed.

## High-level architecture

- This repository is a personal fork of `kickstart.nvim`. It is a Neovim configuration, not a standalone plugin or application.
- `init.lua` is the real entry point and contains most of the configuration: editor options, keymaps, plugin declarations, LSP setup, formatting, completion, and Treesitter.
- `init.lua` bootstraps `lazy.nvim` on startup if it is missing, then registers the plugin graph with `require('lazy').setup(...)`.
- Most plugin configuration stays inline in `init.lua`. Only a few extracted Kickstart modules are actively required near the bottom of that file, notably `kickstart.plugins.autopairs` and `kickstart.plugins.neo-tree`.
- `lua/custom/plugins/` exists, but `{ import = 'custom.plugins' }` is currently commented out in `init.lua`, so files placed there are ignored unless that import is enabled.
- LSP and external tool management are centralized in `init.lua`: Mason installs servers/tools, `vtsls` and `vue_ls` handle JavaScript/TypeScript/Vue support, and `conform.nvim` handles formatting on save.
- Vue TypeScript support is wired through the Mason-installed Vue language server bundle (`stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'`) rather than a system-wide npm install.
- Local snippets live in `snippets/` and are loaded through LuaSnip's SnipMate loader. Custom spelling additions live in `spell/`.
- `lazy-lock.json` is git-ignored, so plugin version pins are local to each machine and changes to it never show up in a diff.

## Key conventions

- Follow the existing Kickstart-style `lazy.nvim` plugin spec tables. When changing a plugin that is already configured inline, edit the inline block in `init.lua` instead of creating a new module elsewhere.
- Do not add files under `lua/custom/plugins/` unless you also enable `{ import = 'custom.plugins' }` in `init.lua`.
- Preserve the repository's Lua formatting rules from `.stylua.toml`: 2-space indentation, single quotes when possible, width 160, and no forced call parentheses.
- Prefer Mason/Conform-managed tooling over ad hoc shell hooks. Lua formatting uses `stylua`; CSS/HTML/JS/TS/Vue formatting is configured through `prettierd`/`prettier` in Conform.
- Keymaps use the `<space>` leader and always set a descriptive `desc`. Match the pattern already used where the keymap lives:
  - General keymaps: `vim.keymap.set(...)` at the top level of `init.lua`.
  - LSP keymaps: the buffer-local `map(keys, func, desc)` helper inside the `LspAttach` callback.
  - Keymaps that should lazy-load a plugin: the plugin spec's `keys` table.
- New `<leader>` keymaps belong under an existing which-key group (registered in the `which-key.nvim` config): `<leader>c` Code, `<leader>d` Document, `<leader>r` Rename, `<leader>s` Search, `<leader>w` Workspace, `<leader>t` Toggle, `<leader>h` Git Hunk. Start the `desc` with the group's bracketed letter (for example `[C]ode [F]ormat buffer`). Only add a new group when none of these fit, and register it with which-key at the same time.
- TypeScript/Vue behavior is built around `vtsls` plus `vue_ls`, not `tsserver`. The custom organize-imports keymap (`<leader>co`) uses synchronous `workspace/executeCommand` calls to remove unused imports and then organize the rest.
- `kickstart.plugins.lint` exists and configures `markdownlint`, but it is currently commented out in `init.lua`, so markdown linting is not active unless that module is enabled.
