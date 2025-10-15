--- @class wizard.Plugin
--- @field [1] string Plugin main module name.
--- @field [2] table<string, any>? Options to pass to the plugin setup function.

---@param plugin_list? wizard.Plugin[]
return function(plugin_list)
  if not plugin_list then
    return
  end

  for _, plugin in ipairs(plugin_list) do
    local module = plugin[1]
    local config = plugin[2]

    require(module).setup(config or {})
  end
end
