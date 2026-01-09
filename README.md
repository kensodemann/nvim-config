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

I have decided to subscribe to GitHub Copilot because it seems well worth the $100 / year. I am using the following two plugins for the integration:

- `zbirenbaum/copilot.lua`: Used for insertions. Most important hotkey: `<C-i>` to insert the current suggestion.
- `CopilotC-Nvim/CopilotChat.nvim`: Used for chat mode. Use `<space>cc` for chat mode, `<space>ct` to generate tests, and `<space>ce` to explain some code.

I have not integrated Copilot with "blink" (part of the suggestion system). Using the "ghost" text and `<C-i>` inserting it works really well, so I am going to stick with that for now.

#### Previous

I was using [gp.nvim](https://github.com/Robitx/gp.nvim) with free-tier Open AI and Gemini API keys. For paid tier, it looks like [Claude](https://www.anthropic.com/api) may be a good option but first let's see if I run out of resources with the free tiers.

I could also use this with Copilot, but I really like how the Copilot plugins I am using right now work OOTB, and there is a lot less configuration required, so I am likely to stick with that. Just leaving this noted here in case I run into limitations.

