--- @class wizard.LspConfig
--- @field settings? table<string, any> LSP configuration.
--- @field on_attach? fun(client: vim.lsp.Client, bufnr: number) Function to run when the LSP server attaches to a buffer.
--- @field code_actions_on_save? string[] Code actions to run on save.
--- @field disable_semantic_tokens? boolean Whether or not to disable LSP semantic tokens, in favor of e.g. Treesitter.

--- @class wizard.Lsp
--- @field [1] string LSP server name.
--- @field [2] wizard.LspConfig? Configuration for the LSP server.

---@param lsp_list? wizard.Lsp[]
return function(lsp_list)
  if not lsp_list then
    return
  end

  local group = vim.api.nvim_create_augroup("WizardConfigLsp", { clear = true })

  for _, lsp in ipairs(lsp_list) do
    local name = lsp[1]
    local config = lsp[2]

    if config then
      ---@type vim.lsp.Config
      local lsp_config = {
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
              desc = string.format("Execute code actions before buffer is written (%s)", name),
            })
          end

          if config.on_attach then
            config.on_attach(client, bufnr)
          end
        end,
      }

      vim.lsp.config(name, lsp_config)
    end

    vim.lsp.enable(name)
  end
end
