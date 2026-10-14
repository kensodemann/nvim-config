# My Neovim Config

This is a fork of the excellent [Neovim Kickstart](https://github.com/nvim-lua/kickstart.nvim) configuration. I highly suggest starting there and then customizing your configuration from there. Be sure to also watch [The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o).

## Installation

Here are my steps (this is for a Mac, which is primarily what I use):

- `brew install neovim tree-sitter-cli`
- Open terminal
- `mkdir .config` and/or `cd .config`
- `git clone git@bitbucket.org:kensodemann/recreation-planner.git nvim`

That is pretty much it. Next time I start `nvim` it asks to install the plugins (answer "Always"), and everything should load.

Plugins are managed by Neovim's built-in `vim.pack` (Neovim 0.12+), and versions are pinned in `nvim-pack-lock.json`. Use `:PackUpdate` to update plugins, `:PackStatus` to see what is installed, and `:PackClean` to remove plugins that are no longer in the config.

Treesitter parsers, `telescope-fzf-native`, and LuaSnip's regex support are compiled locally, so the Xcode / Command Line Tools C compiler has to work. If builds fail with `ld: tapi error ... unknown architecture` after a macOS upgrade, the selected Xcode is older than the SDK; update Xcode or run `sudo xcode-select --switch /Library/Developer/CommandLineTools`.

## Commands and Shortcuts

- `<leader>` is currently set to the spacebar
- Diagnostic text shows at the end of the line: `[d` / `]d` open the full message.
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
- **Spelling:**
  - `]s` / `[s` next / previous misspelled word
  - `z=` show suggestions. Type a number and press Enter to accept one
  - `zg` add the word to the dictionary
  - `zw` mark the word as wrong
  - `zug` / `zuw` undo `zg` / `zw`

## Managing plugins

`vim.pack` is being used to manage plugins.

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


## Configuration Notes

There are a few quirks or manual steps in order for me to set up Neovim entirely.

### Tailwind CSS

I use the VS Code extension for this. It is easy to install via `:LspInstall tailwindcss`, I just need to remember to actually do it... 🤓 

### AI Agents

#### Current

No AI agent is currently integrated into this configuration.

#### Previous

I used GitHub Copilot through `zbirenbaum/copilot.lua` (inline suggestions) and `CopilotC-Nvim/CopilotChat.nvim` (chat). I removed both once I stopped using Copilot on my projects.

Before that, I was using [gp.nvim](https://github.com/Robitx/gp.nvim) with free-tier Open AI and Gemini API keys. For paid tier, it looks like [Claude](https://www.anthropic.com/api) may be a good option but first let's see if I run out of resources with the free tiers.

