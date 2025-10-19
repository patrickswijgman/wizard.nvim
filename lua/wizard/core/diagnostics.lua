---@class wizard.Diagnostics : vim.diagnostic.Opts
---@field icons table<vim.diagnostic.Severity, string> Diagnostic icons for virtual text and lines.
---@field signs table<vim.diagnostic.Severity, string> Diagnostic icons for the sign column.

---@param config? wizard.Diagnostics
return function(config)
  if not config then
    return
  end

  if config.icons then
    ---@type vim.diagnostic.Opts
    local extra_config = {
      virtual_text = {
        prefix = "",
        format = function(diagnostic)
          return string.format("%s %s", config.icons[diagnostic.severity], diagnostic.message)
        end,
      },
      virtual_lines = {
        prefix = "",
        format = function(diagnostic)
          return string.format("%s %s", config.icons[diagnostic.severity], diagnostic.message)
        end,
      },
    }

    config = vim.tbl_deep_extend("keep", config, extra_config)
  end

  if config.signs then
    ---@type vim.diagnostic.Opts
    local extra_config = {
      signs = {
        text = config.signs,
      },
    }

    config = vim.tbl_deep_extend("keep", config, extra_config)
  end

  vim.diagnostic.config(config)
end
