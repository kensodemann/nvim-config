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

