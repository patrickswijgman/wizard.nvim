local M = {}

--- @class wizard.KeymapOpts
--- @field mode? string|string[] Modes in which the keymap is active. Defaults to "n" (normal mode).
--- @field remap? boolean Whether the keymap is recursive. Defaults to false (non-recursive).
--- @field expression? boolean Whether the keymap is a Vim language expression.

--- @class wizard.Keymap
--- @field [1] string Key combination to map.
--- @field [2] string|function What the keymap does. Can be a string or a function.
--- @field [3] string Description of the keymap.
--- @field [4] wizard.KeymapOpts? Additional options for the keymap.

--- @class wizard.AutoCmd
--- @field [1] string|string[] Events that trigger the autocommand.
--- @field [2] function Callback function to execute when the autocommand is triggered.
--- @field [3] string Description of the autocommand.

--- @class wizard.LspConfig
--- @field settings? table<string, any> LSP configuration.
--- @field on_attach? fun(client: vim.lsp.Client, bufnr: number) Function to run when the LSP server attaches to a buffer.
--- @field code_actions_on_save? table<string> Code actions to run on save.
--- @field disable_semantic_tokens? boolean Whether or not to disable LSP semantic tokens, in favor of e.g. Treesitter.

--- @class wizard.Lsp
--- @field [1] string LSP server name.
--- @field [2] wizard.LspConfig? Configuration for the LSP server.

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

--- @param opts wizard.Opts
function M.setup(opts)
  for key, value in pairs(opts.options or {}) do
    vim.o[key] = value
  end

  for key, value in pairs(opts.global_options or {}) do
    vim.g[key] = value
  end

  local group = vim.api.nvim_create_augroup("Wizard", { clear = true })

  for _, autocmd in ipairs(opts.autocmds or {}) do
    local events = autocmd[1]
    local callback = autocmd[2]
    local desc = autocmd[3]

    vim.api.nvim_create_autocmd(events, {
      callback = callback,
      group = group,
      desc = desc,
    })
  end

  for _, lsp in ipairs(opts.lsp or {}) do
    local name = lsp[1]
    local config = lsp[2]

    if config then
      vim.lsp.config(name, {
        settings = config.settings,
        on_attach = function(client, bufnr)
          if config.disable_semantic_tokens then
            client.server_capabilities.semanticTokensProvider = nil
          end

          if config.code_actions_on_save then
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function()
                vim.lsp.buf.code_action({
                  context = {
                    only = config.code_actions_on_save,
                    diagnostics = {},
                  },
                  apply = true,
                })
              end,
              group = group,
              buffer = bufnr,
              desc = "Execute code actions before buffer is written",
            })
          end

          if config.on_attach then
            config.on_attach(client, bufnr)
          end
        end,
      })
    end

    vim.lsp.enable(name)
  end

  if opts.diagnostics then
    vim.diagnostic.config(opts.diagnostics)
  end

  if opts.colorscheme then
    vim.cmd.colorscheme(opts.colorscheme)
  end

  for _, plugin in ipairs(opts.plugins or {}) do
    local module = plugin[1]
    local config = plugin[2]

    require(module).setup(config or {})
  end

  for _, keymap in ipairs(opts.keymaps or {}) do
    local lhs = keymap[1]
    local rhs = keymap[2]
    local desc = keymap[3]
    local keymap_opts = keymap[4] or {}
    local keymap_mode = keymap_opts.mode or "n"

    vim.keymap.set(keymap_mode, lhs, rhs, { desc = desc, silent = true, remap = keymap_opts.remap, expr = keymap_opts.expression })
  end
end

return M
