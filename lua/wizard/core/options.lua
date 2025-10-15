---@alias wizard.Options table<string, any>

---@param options? wizard.Options
---@param global_options? wizard.Options
return function(options, global_options)
  for key, value in pairs(options or {}) do
    vim.o[key] = value
  end

  for key, value in pairs(global_options or {}) do
    vim.g[key] = value
  end
end
