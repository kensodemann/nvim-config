# Agent Instructions

## Build, test, and lint commands

- There is no repo-level build script or automated test suite in this repository. `.github/workflows/stylua.yml` is inherited from Kickstart and only runs on the upstream `nvim-lua/kickstart.nvim` repo, so no CI runs for this fork.
- `stylua` is installed by Mason and is not on the shell `PATH`. Use the full path `~/.local/share/nvim/mason/bin/stylua`.
- Check Lua formatting: `~/.local/share/nvim/mason/bin/stylua --check .`
- Format Lua files: `~/.local/share/nvim/mason/bin/stylua .`
- Check that the config loads: `nvim --headless +qa`. Any output means `init.lua` or a plugin raised an error; Neovim exits `0` even when that happens, so check the output rather than the exit code.
- Health checks must be written to a file to be readable headlessly: `nvim --headless "+checkhealth vim.pack blink.cmp nvim-treesitter" "+w! /tmp/health.txt" +qa`. The blink.cmp warning about the fuzzy lib not being downloaded is expected (the Lua matcher is used).
- Headless Neovim does not run the interactive insert-mode loop, so completion-menu behavior cannot be tested with `--headless`; leaving insert mode open in a headless test hangs the process.

## High-level architecture

- This repository is a personal fork of `kickstart.nvim`, synced with upstream's `vim.pack` rewrite. It is a Neovim configuration, not a standalone plugin or application. It requires Neovim 0.12+.
- `init.lua` is the entry point and is split into numbered `do ... end` sections: options, keymaps/autocmds, plugin-manager build hooks, UI plugins, Telescope, LSP, formatting, completion/snippets, Treesitter, and optional modules.
- Plugins are installed with Neovim's built-in `vim.pack` (`vim.pack.add { gh 'owner/repo' }`) followed immediately by the plugin's `setup()` call. There is no lazy loading; everything loads at startup in file order, so a plugin must be added before any section that `require`s it.
- Post-install build steps (`telescope-fzf-native.nvim`, `LuaSnip`, `nvim-treesitter`) run from the `PackChanged` autocommand in section 3, not from plugin specs.
- Plugins live in `~/.local/share/nvim/site/pack/core/opt/`. Versions are pinned in `nvim-pack-lock.json`, which is tracked in git. Section 3 defines `:PackUpdate`, `:PackStatus`, and `:PackClean` as wrappers around `vim.pack.update()` / `vim.pack.del()`.
- The optional modules in `lua/kickstart/plugins/` are plain scripts that call `vim.pack.add` themselves. `autopairs` and `neo-tree` are required in section 10; `debug`, `indent_line`, and `lint` are commented out.
- `lua/custom/plugins/init.lua` loads every other file in that directory, but `require 'custom.plugins'` is commented out in `init.lua`, so files placed there are ignored unless that line is enabled.
- LSP: Mason installs servers/tools, `vtsls` and `vue_ls` handle JavaScript/TypeScript/Vue, `lua_ls` handles Lua, and `stylua` runs as an LSP. `mason-lspconfig` has `automatic_enable = true`, so servers installed manually through `:Mason`/`:LspInstall` (e.g. Tailwind) are also started.
- Vue TypeScript support is wired through the Mason-installed Vue language server bundle (`stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'`) rather than a system-wide npm install.
- Completion is `blink.cmp` (version `1.*`) with LuaSnip as the snippet engine. blink registers its LSP capabilities itself, so do not merge completion capabilities into server configs.
- Snippets: friendly-snippets loads through LuaSnip's VS Code loader; the custom snippets in `snippets/` are SnipMate format and load through LuaSnip's SnipMate loader. Custom spelling additions live in `spell/`.
- Treesitter uses the `main` branch of `nvim-treesitter`. Parsers install to `~/.local/share/nvim/site/parser/` and are compiled locally, which needs `tree-sitter-cli` (Homebrew `tree-sitter-cli`) and a working C toolchain. Missing parsers are installed automatically on `FileType`.

## Key conventions

- Follow the existing section structure. When changing a plugin that is already configured, edit its block in `init.lua` instead of creating a new module elsewhere. New plugins go in the section that matches their purpose, as a `vim.pack.add` call followed by `setup()`.
- Do not add files under `lua/custom/plugins/` unless you also enable `require 'custom.plugins'` in `init.lua`.
- Preserve the repository's Lua formatting rules from `.stylua.toml`: 2-space indentation, single quotes when possible, width 160, no forced call parentheses, and simple one-statement functions collapsed onto one line.
- Prefer Mason/Conform-managed tooling over ad hoc shell hooks. Lua formatting uses `stylua`; CSS/HTML/JS/TS/Vue formatting is configured through `prettierd`/`prettier` in Conform. Conform's `lsp_format` option is used (not the deprecated `lsp_fallback`).
- Keymaps use the `<space>` leader and always set a descriptive `desc`. Match the pattern already used where the keymap lives:
  - General keymaps: `vim.keymap.set(...)` inside the relevant section.
  - Telescope-based LSP pickers (`gd`, `gr`, `gI`, `<leader>D`, `<leader>ds`, `<leader>ws`): the `LspAttach` autocommand in the Telescope section.
  - Other LSP keymaps: the buffer-local `map(keys, func, desc, mode)` helper inside the `LspAttach` callback in the LSP section.
  - gitsigns keymaps: the gitsigns `on_attach` function.
  - Completion keymaps: the `keymap` table in the blink.cmp setup.
- New `<leader>` keymaps belong under an existing which-key group (registered in the `which-key.nvim` `spec`): `<leader>c` Code, `<leader>d` Document, `<leader>r` Rename, `<leader>s` Search, `<leader>w` Workspace, `<leader>t` Toggle, `<leader>h` Git Hunk. Start the `desc` with the group's bracketed letter (for example `[C]ode [F]ormat buffer`). Only add a new group when none of these fit, and register it with which-key at the same time.
- TypeScript/Vue behavior is built around `vtsls` plus `vue_ls`, not `tsserver`. The custom organize-imports keymap (`<leader>co`) uses synchronous `workspace/executeCommand` calls to remove unused imports and then organize the rest.
- `mini.ai`'s "next" text objects are remapped to `aa`/`ii` because Neovim 0.12 uses `an`/`in` for built-in incremental selection.
