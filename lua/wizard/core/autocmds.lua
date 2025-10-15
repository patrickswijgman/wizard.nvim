--- @class wizard.AutoCmd
--- @field [1] string|string[] Events that trigger the autocommand.
--- @field [2] function Callback function to execute when the autocommand is triggered.
--- @field [3] string Description of the autocommand.

---@param autocmd_list? wizard.AutoCmd[]
return function(autocmd_list)
  if not autocmd_list then
    return
  end

  local group = vim.api.nvim_create_augroup("WizardConfigAutocmd", { clear = true })

  for _, autocmd in ipairs(autocmd_list) do
    local events = autocmd[1]
    local callback = autocmd[2]
    local desc = autocmd[3]

    vim.api.nvim_create_autocmd(events, {
      callback = callback,
      group = group,
      desc = desc,
    })
  end
end
