--- @class wizard.KeymapOpts
--- @field mode? string|string[] Modes in which the keymap is active. Defaults to "n" (normal mode).
--- @field remap? boolean Whether the keymap is recursive. Defaults to false (non-recursive).
--- @field expression? boolean Whether the keymap is a Vim language expression.

--- @class wizard.Keymap
--- @field [1] string Key combination to map.
--- @field [2] string|function What the keymap does. Can be a string or a function.
--- @field [3] string Description of the keymap.
--- @field [4] wizard.KeymapOpts? Additional options for the keymap.

--- @param keymap_list wizard.Keymap[] List of keymaps to set.
return function(keymap_list)
  if not keymap_list then
    return
  end

  for _, keymap in ipairs(keymap_list) do
    local lhs = keymap[1]
    local rhs = keymap[2]
    local desc = keymap[3]
    local opts = keymap[4] or {}
    local mode = opts.mode or "n"

    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, remap = opts.remap, expr = opts.expression })
  end
end
