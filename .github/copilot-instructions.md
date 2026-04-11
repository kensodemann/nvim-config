# Copilot Instructions

## Build, test, and lint commands

- There is no repo-level build script or automated test suite in this repository.
- Check Lua formatting: `stylua --check .`
- Format Lua files: `stylua .`
- Check a single file: `stylua --check init.lua`
- Runtime sanity check inside Neovim: `nvim --headless "+checkhealth kickstart" +qa`

## High-level architecture

- This repository is a personal fork of `kickstart.nvim`. It is a Neovim configuration, not a standalone plugin or application.
- `init.lua` is the real entry point and contains most of the configuration: editor options, keymaps, plugin declarations, LSP setup, formatting, completion, Treesitter, and Copilot integration.
- `init.lua` bootstraps `lazy.nvim` on startup if it is missing, then registers the plugin graph with `require('lazy').setup(...)`.
- Most plugin configuration stays inline in `init.lua`. Only a few extracted Kickstart modules are actively required near the bottom of that file, notably `kickstart.plugins.autopairs` and `kickstart.plugins.neo-tree`.
- `lua/custom/plugins/` exists, but `{ import = 'custom.plugins' }` is currently commented out in `init.lua`, so files placed there are ignored unless that import is enabled.
- LSP and external tool management are centralized in `init.lua`: Mason installs servers/tools, `vtsls` and `vue_ls` handle JavaScript/TypeScript/Vue support, and `conform.nvim` handles formatting on save.
- Vue TypeScript support is wired through the Mason-installed Vue language server bundle (`stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'`) rather than a system-wide npm install.
- Local snippets live in `snippets/` and are loaded through LuaSnip's SnipMate loader. Custom spelling additions live in `spell/`.

## Key conventions

- Follow the existing Kickstart-style `lazy.nvim` plugin spec tables. When changing a plugin that is already configured inline, edit the inline block in `init.lua` instead of creating a new module elsewhere.
- Do not add files under `lua/custom/plugins/` unless you also enable `{ import = 'custom.plugins' }` in `init.lua`.
- Preserve the repository's Lua formatting rules from `.stylua.toml`: 2-space indentation, single quotes when possible, width 160, and no forced call parentheses.
- Prefer Mason/Conform-managed tooling over ad hoc shell hooks. Lua formatting uses `stylua`; CSS/HTML/JS/TS/Vue formatting is configured through `prettierd`/`prettier` in Conform.
- New keymaps should keep the existing pattern: `<space>` leader, `vim.keymap.set(...)`, and a descriptive `desc`.
- TypeScript/Vue behavior is built around `vtsls` plus `vue_ls`, not `tsserver`, and the custom organize-imports mapping uses synchronous `workspace/executeCommand` calls.
- `kickstart.plugins.lint` exists and configures `markdownlint`, but it is currently commented out in `init.lua`, so markdown linting is not active unless that module is enabled.
- Copilot is part of the active config: `zbirenbaum/copilot.lua` handles inline suggestions and `CopilotChat.nvim` is mapped on `<leader>cc`, `<leader>ct`, and `<leader>ce`.
