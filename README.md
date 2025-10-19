# Wizard

Setup the things (with some extras) you need from a single `init.lua` file.

## Example

```lua
-- Example: enable experimental loader for faster lua module loading.
vim.loader.enable()

require("wizard").setup({
  -- Options that you would normally set with `vim.opt` or `vim.o`.
  options = {
    mouse = "a",
    number = true,
    relativenumber = true,
    cursorline = true,
    signcolumn = "yes",
    colorcolumn = "",
    scrolloff = 8,
  },

  -- Options that you would normally set with `vim.g`.
  global_options = {
    mapleader = " ",
    loaded_netrw = 1,
    loaded_netrwPlugin = 1,
  },

  -- Set the colorscheme.
  -- Can come from a plugin, most of which you don't need to configure, but if
  -- you need to you can add it to the plugins section below.
  colorscheme = "catppuccin",

  -- List of plugins to setup.
  -- NOTE that you do need a plugin manager for this to work. Personally I
  -- use NixOS so I manage my Neovim plugins in there.
  plugins = {
    {
      -- Plugin module name (that you would normally pass to `require`).
      "telescope",

      -- Plugin options that are passed to the plugin's `setup` function.
      {
        defaults = {
          mappings = {
            i = {
              ["<c-up>"] = require("telescope.actions").cycle_history_prev,
              ["<c-down>"] = require("telescope.actions").cycle_history_next,
              ["<tab>"] = require("telescope.actions.layout").toggle_preview,
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
      },
    },
  },

  -- Setup your keymaps.
  -- NOTE keymaps are bound to only normal mode by default.
  keymaps = {
    -- Example: expressions and set keymap to multiple modes
    { "j", "v:count == 0 ? 'gj' : 'j'", "Down (including wrapped lines)", { mode = { "n", "x" }, expression = true } },
    { "k", "v:count == 0 ? 'gk' : 'k'", "Up (including wrapped lines)", { mode = { "n", "x" }, expression = true } },

    -- Example: commands
    { "<c-h>", "<cmd>tabprev<cr>", "Go to previous tab" },
    { "<c-l>", "<cmd>tabnext<cr>", "Go to next tab" },
    { "<c-t>", "<cmd>tabnew<cr>", "New tab" },
    { "<c-q>", "<cmd>tabclose<cr>", "Close tab" },

    -- Example: functions (from plugins)
    { "<leader>d", require("telescope.builtin").diagnostics, "Diagnostics" },
    { "<leader>f", require("telescope.builtin").find_files, "Find file" },
    { "<leader>/", require("telescope.builtin").live_grep, "Grep content" },
    { "<leader>?", require("telescope.builtin").grep_string, "Grep word under cursor" },
    { "<leader>b", require("telescope.builtin").buffers, "Find buffer" },
    { "<leader>h", require("telescope.builtin").help_tags, "Find help" },
    { "<leader>'", require("telescope.builtin").resume, "Resume last picker" },
  },

  -- Setup auto commands.
  -- NOTE only callback functions are supported.
  autocmds = {
    {
      { "TextYankPost" },
      function()
        vim.hl.on_yank()
      end,
      "Highlight on yank",
    },
  },

  -- Configure diagnostics.
  diagnostics = {
    float = {
      border = "rounded",
    },
    virtual_text = {
      current_line = true,
    },
    -- Extra: Diagnostic icons for virtual and line text.
    icons = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    }
    -- Extra: Diagnostic icons for sign column.
    signs = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },

  -- Setup language servers.
  -- NOTE that you do need to install language servers yourself. Either with
  -- a manager like Mason or manually. Personally I use NixOS so I manage my
  -- language servers in there.
  lsp = {
    {
      -- Language server name.
      -- If you've installed `nvim-lspconfig` you can find LSPs here:
      -- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
      "lua_ls",
      -- Language server config.
      {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
        -- Extra: Disable semantic tokens, in favor of e.g. Treesitter.
        disable_semantic_tokens = true,
      },
    },
    {
      "biome",
      {
        -- Extra: Execute these LSP code actions before buffer is written.
        code_actions_on_save = { "source.fixAll.biome", "source.organizeImports.biome" },
      },
    },
  },
})
```
