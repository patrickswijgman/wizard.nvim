---@param colorscheme? string
return function(colorscheme)
  if not colorscheme then
    return
  end

  vim.cmd.colorscheme(colorscheme)
end
