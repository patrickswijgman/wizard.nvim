---@class wizard.Diagnostics : vim.diagnostic.Opts

---@param config? wizard.Diagnostics
return function(config)
  vim.diagnostic.config(config)
end
