
require("sunset").setup({
      priority = 1000,
      latitude =  43.2389,
      longitude = 76.88,
      day_callback = function()
        vim.cmd.colorscheme('rose-pine-dawn')
      end,
      night_callback = function()
        vim.cmd.colorscheme('rose-pine-moon')
      end,
      update_interval = 100,
      --sunrise_offset = 1800,
      --sunset_offset = -1800,
})

-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
--if not status_ok then
--  vim.notify("colorscheme " .. colorscheme .. " not found!")
--  return
-- end
