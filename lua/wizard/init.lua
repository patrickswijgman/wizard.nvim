local M = {}

--- @class wizard.Keymap
--- @field [1] string Mode(s) of the keymap.
--- @field [2] string Key combination to map.
--- @field [3] string|function What the keymap does. Can be a string or a function.
--- @field [4] vim.keymap.set.Opts? Additional options for the keymap.

--- @class wizard.AutoCmd
--- @field [1] string|string[] Event(s) that trigger the autocommand.
--- @field [2] vim.api.keyset.create_autocmd Autocmd options.

--- @class wizard.Lsp
--- @field [1] string LSP server name.
--- @field [2] vim.lsp.Config? Configuration for the LSP server.

--- @class wizard.Plugin
--- @field [1] string Plugin main module name.
--- @field [2] table<string, any>? Options to pass to the plugin setup function.

--- @class wizard.Opts
--- @field options? table<string, any> Editor options.
--- @field global_options? table<string, any> Editor global options.
--- @field keymaps? wizard.Keymap[] Keymaps to set. By default non-recursive, silent keymaps in normal mode.
--- @field autocmds? wizard.AutoCmd[] Autocommands to create.
--- @field lsp? wizard.Lsp[] LSP configurations.
--- @field diagnostics? vim.diagnostic.Opts Diagnostic options.
--- @field colorscheme? string Colorscheme to set.
--- @field plugins? wizard.Plugin[] Plugins to load and configure.
--- @field filetypes? vim.filetype.add.filetypes Filetype associations to set.

--- @param opts wizard.Opts
function M.setup(opts)
  for key, value in pairs(opts.options or {}) do
    vim.o[key] = value
  end

  for key, value in pairs(opts.global_options or {}) do
    vim.g[key] = value
  end

  for _, autocmd in ipairs(opts.autocmds or {}) do
    local events = autocmd[1]
    local config = autocmd[2]

    vim.api.nvim_create_autocmd(events, config)
  end

  for _, lsp in ipairs(opts.lsp or {}) do
    local name = lsp[1]
    local config = lsp[2]

    if config then
      vim.lsp.config(name, config)
    end

    vim.lsp.enable(name)
  end

  if opts.diagnostics then
    vim.diagnostic.config(opts.diagnostics)
  end

  for _, plugin in ipairs(opts.plugins or {}) do
    local module = plugin[1]
    local config = plugin[2]

    require(module).setup(config or {})
  end

  if opts.colorscheme then
    vim.cmd.colorscheme(opts.colorscheme)
  end

  for _, keymap in ipairs(opts.keymaps or {}) do
    local mode = keymap[1]
    local lhs = keymap[2]
    local rhs = keymap[3]
    local config = keymap[4]

    vim.keymap.set(mode, lhs, rhs, config)
  end

  if opts.filetypes then
    vim.filetype.add(opts.filetypes)
  end
end

return M
