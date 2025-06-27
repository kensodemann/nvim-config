# My Neovim Config

This is a fork of the excellent [Neovim Kickstart](https://github.com/nvim-lua/kickstart.nvim) configuration. I highly suggest starting there and then customizing your configuration from there. Be sure to also watch [The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o).

## Installation

Here are my steps (this is for a Mac, which is primarily what I use):

- `brew install neovim`
- Open terminal
- `mkdir .config` and/or `cd .config`
- `git clone git@bitbucket.org:kensodemann/recreation-planner.git nvim`

That is pretty much it. Next time I start `nvim` everything should load.

## Configuration Notes

There are a few quirks or manual steps in order for me to set up Neovim entirely.

### Tailwind CSS

I use the VS Code extension for this. It is easy to install via `:LspInstall tailwindcss`, I just need to remember to actually do it... 🤓 

### AI Agents

#### Current

I am currently using [gp.nvim](https://github.com/Robitx/gp.nvim) with free-tier Open AI and Gemini API keys. For paid tier, it looks like [Claude](https://www.anthropic.com/api) may be a good option but first let's see if I run out of resources with the free tiers.

#### Previous

I used to use [Pieces](https://pieces.app/) primarily to provide chat style AI help. I am also experimenting with the Snippets feature.

To reinstall at some point if needed, reinstate the remove line in the config:

```
   'kyazdani42/nvim-web-devicons',
   'MunifTanjim/nui.nvim',
-  'pieces-app/plugin_neovim',
```

Then be sure to do the following:

- `brew install --cask pieces`
- Open Pieces and log in.
- If Python is installed via Homebrew, uninstall it.
- Manually install [Python](https://www.python.org/downloads/).
- `pip3 install pynvim`
- Start `nvim` and `:UpdateRemotePlugins`
