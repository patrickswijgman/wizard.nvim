local setup_options = require("wizard.core.options")
local setup_autocmds = require("wizard.core.autocmds")
local setup_lsp = require("wizard.core.lsp")
local setup_diagnostics = require("wizard.core.diagnostics")
local setup_colorscheme = require("wizard.core.colorscheme")
local setup_plugins = require("wizard.core.plugins")
local setup_keymaps = require("wizard.core.keymaps")

local M = {}

--- @class wizard.Opts
--- @field options? wizard.Options Editor options.
--- @field global_options? wizard.Options Editor global options.
--- @field keymaps? wizard.Keymap[] Keymaps to set. By default non-recursive, silent keymaps in normal mode.
--- @field autocmds? wizard.AutoCmd[] Autocommands to create.
--- @field lsp? wizard.Lsp[] LSP configurations.
--- @field diagnostics? wizard.Diagnostics Diagnostic options.
--- @field colorscheme? string Colorscheme to set.
--- @field plugins? wizard.Plugin[] Plugins to load and configure.

--- @param opts? wizard.Opts
function M.setup(opts)
  if not opts then
    return
  end

  setup_options(opts.options, opts.global_options)
  setup_autocmds(opts.autocmds)
  setup_lsp(opts.lsp)
  setup_diagnostics(opts.diagnostics)
  setup_colorscheme(opts.colorscheme)
  setup_plugins(opts.plugins)
  setup_keymaps(opts.keymaps)
end

return M
