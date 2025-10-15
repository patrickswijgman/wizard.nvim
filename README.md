# Wizard

Setup the things you need from a single `init.lua` file.

## Example

```lua
vim.loader.enable()

require("wizard").setup({
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

  colorscheme = "catppuccin",

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

  keymaps = {
    { "j", "v:count == 0 ? 'gj' : 'j'", "Down (including wrapped lines)", { mode = { "n", "x" }, expression = true } },
    { "k", "v:count == 0 ? 'gk' : 'k'", "Up (including wrapped lines)", { mode = { "n", "x" }, expression = true } },

    { "<c-h>", "<cmd>tabprev<cr>", "Go to previous tab" },
    { "<c-l>", "<cmd>tabnext<cr>", "Go to next tab" },
    { "<c-t>", "<cmd>tabnew<cr>", "New tab" },
    { "<c-q>", "<cmd>tabclose<cr>", "Close tab" },

    { "<leader>d", require("telescope.builtin").diagnostics, "Diagnostics" },
    { "<leader>f", require("telescope.builtin").find_files, "Find file" },
    { "<leader>/", require("telescope.builtin").live_grep, "Grep content" },
    { "<leader>?", require("telescope.builtin").grep_string, "Grep word under cursor" },
    { "<leader>b", require("telescope.builtin").buffers, "Find buffer" },
    { "<leader>h", require("telescope.builtin").help_tags, "Find help" },
    { "<leader>'", require("telescope.builtin").resume, "Resume last picker" },
  },

  autocmds = {
    {
      "TextYankPost",
      function()
        vim.hl.on_yank()
      end,
      "Highlight on yank",
    },
  },

  diagnostics = {
    virtual_text = {
      current_line = true,
    },
  },

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

        -- Extra setting: Disable semantic tokens, in favor of e.g. Treesitter.
        disable_semantic_tokens = true,
      },
    },
    {
      "biome",
      {
        -- Extra setting: Execute these LSP code actions before buffer is written.
        code_actions_on_save = { "source.fixAll.biome", "source.organizeImports.biome" },
      },
    },
  },
})
```
