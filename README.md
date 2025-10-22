# Wizard

Setup the things you need from a single `init.lua` file.

## Example

> [!NOTE]
> All configuration options are optional, so only use what you need :)

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

  -- See `:h nvim_create_autocmd()` for more information about auto command configuration.

  autocmds = {
    {
      -- Example: Highlight yanked text briefly.
      "TextYankPost",
      {
        callback = function()
          vim.hl.on_yank()
        end,
        desc = "Highlight on yank",
      },
    },
  },

  -----------------
  -- Diagnostics --
  -----------------

  -- `virtual_text` and `virtual_lines` can be configured at the same time or not
  -- at all. But you'll most likely want to configure at least one of the two because
  -- otherwise you will not get any diagnostics (Neovim default behavior since 0.11).

  -- See `:h vim.diagnostic.config()` for more information about diagnostic configuration.

  diagnostics = {
    -- Example: Set border for floating window when invoked with e.g. <c-w>d
    float = {
      border = "rounded",
    },

    -- Example: Show virtual text with icons.
    virtual_text = {
      current_line = true,
      prefix = "",
      format = function(diagnostic)
        local icons = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.INFO] = "󰋽",
          [vim.diagnostic.severity.HINT] = "󰌶",
        }

        return string.format("%s %s", icons[diagnostic.severity], diagnostic.message)
      end
    },

    -- Example: Always show virtual lines, but only for errors.
    virtual_lines = {
      current_line = false,
      severity = {
        vim.diagnostic.severity.ERROR,
      }
    },

    -- Example: Set icons in sign column.
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
  },

  ----------------------------
  -- Language servers (LSP) --
  ----------------------------

  -- You can omit this option if you use e.g. Mason to download and setup your LSP.

  -- If you use `nvim-lspconfig` you can find LSPs here https://github.com/neovim/nvim-lspconfig/tree/master/lsp

  -- See `:h lsp-config` for more information about language server configuration.

  lsp = {
    {
      -- Example: Configure Lua language server for Neovim.
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

        -- Example: Do something when the language server attaches to a buffer.
        on_attach = function(client, bufnr)
          -- If you use Treesitter you might want to disable semantic tokens for
          -- language servers that use them to prevent race conditions.
          client.server_capabilities.semanticTokensProvider = nil
        end
      },
    },
  },

  ---------------------------
  -- Filetype associations --
  ---------------------------

  -- See `:h vim.filetype` for more information about filetype configuration.

  filetypes = {
    -- Example: associate all .env files with the 'properties' filetype.
    [".*%.env.*""] = "properties"
  }
})
```
