---@class wizard.DiagnosticsVirtualMessage
---@field current_line? boolean Whether or not to show only for the current line.
---@field icons? table<vim.diagnostic.Severity, string> Diagnostic icons for severity levels.
---@field severity? vim.diagnostic.Severity[] Show only for given severities.

---@class wizard.DiagnosticsSignColumn
---@field icons? table<vim.diagnostic.Severity, string> Diagnostic icons for severity levels.
---@field severity? vim.diagnostic.Severity[] Show only for given severities.

---@class wizard.Diagnostics
---@field virtual_text? wizard.DiagnosticsVirtualMessage Configuration for virtual text diagnostics.
---@field virtual_lines? wizard.DiagnosticsVirtualMessage Configuration for virtual lines diagnostics.
---@field signs? wizard.DiagnosticsSignColumn Configuration for the sign column.
---@field float? vim.diagnostic.Opts.Float Configuration for floating diagnostics window.

---@param config? wizard.Diagnostics
return function(config)
  if not config then
    return
  end

  ---@type vim.diagnostic.Opts
  local diagnostic_config = {}

  if config.virtual_text then
    diagnostic_config.virtual_text = {
      current_line = config.virtual_text.current_line,
      severity = config.virtual_text.severity,
    }

    if config.virtual_text.icons then
      diagnostic_config.virtual_text.prefix = ""
      diagnostic_config.virtual_text.format = function(diagnostic)
        return string.format("%s %s", config.virtual_text.icons[diagnostic.severity], diagnostic.message)
      end
    end
  end

  if config.virtual_lines then
    diagnostic_config.virtual_lines = {
      current_line = config.virtual_lines.current_line,
      severity = config.virtual_lines.severity,
    }

    if config.virtual_lines.icons then
      diagnostic_config.virtual_lines.format = function(diagnostic)
        return string.format("%s %s", config.virtual_lines.icons[diagnostic.severity], diagnostic.message)
      end
    end
  end

  if config.signs then
    diagnostic_config.signs = {
      text = config.signs.icons,
      severity = config.signs.severity,
    }
  end

  if config.float then
    diagnostic_config.float = config.float
  end

  vim.diagnostic.config(diagnostic_config)
end
