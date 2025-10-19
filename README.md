# Wizard

Setup the things (with some extras) you need from a single `init.lua` file.

## Example

> [!NOTE]
> All options are optional, so only use what you need :)

```lua
vim.loader.enable()

require("wizard").setup({
  --------------------
  -- Editor options --
  --------------------

  options = {
    mouse = "a",
    number = true,
    relativenumber = true,
    cursorline = true,
    signcolumn = "yes",
    colorcolumn = "",
    scrolloff = 8,
  },

  global_options = {
    mapleader = " ",
    loaded_netrw = 1,
    loaded_netrwPlugin = 1,
  },

  -----------------
  -- Colorscheme --
  -----------------

  -- Can come from a plugin, most of which you don't need to configure, but if
  -- you need to you can add it to the plugins section below.

  colorscheme = "catppuccin",

  -------------
  -- Plugins --
  -------------

  -- You can omit this option if you use e.g. Lazy to install and setup your plugins.

  plugins = {
    {
      "telescope",
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

  -------------
  -- Keymaps --
  -------------

  -- By default keymaps are bound to (non-recursive) normal mode.

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

  -------------------
  -- Auto commands --
  -------------------

  -- Only callback functions are supported.

  autocmds = {
    {
      { "TextYankPost" },
      function()
        vim.hl.on_yank()
      end,
      "Highlight on yank",
    },
  },

  -----------------
  -- Diagnostics --
  -----------------

  -- `virtual_text` and `virtual_lines` can be configured at the same time or not
  -- at all. But you'll most likely want to configure at least one of the two because
  -- otherwise you will not get any diagnostics (Neovim default behavior since 0.11).

  -- Omit the `severity` option to show on all severity levels.

  diagnostics = {
    float = {
      border = "rounded",
    },

    virtual_text = {
      current_line = true,
      icons = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "󰋽",
        [vim.diagnostic.severity.HINT] = "󰌶",
      },
      severity = {
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      }
    },

    virtual_lines = {
      current_line = false,
      icons = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "󰋽",
        [vim.diagnostic.severity.HINT] = "󰌶",
      },
      severity = {
        vim.diagnostic.severity.ERROR,
      }
    },

    signs = {
      icons = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
      },
    },
  },

  ----------------------------
  -- Language servers (LSP) --
  ----------------------------

  -- You can omit this option if you use e.g. Mason to download and setup your LSP.

  -- If you use `nvim-lspconfig` you can find LSPs here https://github.com/neovim/nvim-lspconfig/tree/master/lsp

  lsp = {
    {
      "lua_ls",
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

        -- If you use Treesitter you might want to disable semantic tokens for
        -- language servers that use them to prevent race conditions.
        disable_semantic_tokens = true,

        on_attach = function(client, bufnr)
          print("hello")
        end
      },
    },
    {
      "biome",
      {
        -- Execute these LSP code actions before buffer is written.
        code_actions_on_save = { "source.fixAll.biome", "source.organizeImports.biome" },
      },
    },
  },
})
```
