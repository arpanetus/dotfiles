local status_ok, sunset = pcall(require, "sunset")
if not status_ok then
  vim.notify("sunset doesn't exist", vim.log.levels.ERROR)
  return
end


sunset.setup({
      priority = 1000,
      latitude =  43.2389,
      longitude = 76.88,
      day_callback = function()
        vim.cmd.colorscheme('rose-pine-dawn')
        vim.cmd.colorscheme('rose-pine-dawn')
      end,
      night_callback = function()
        vim.cmd.colorscheme('rose-pine-main')
        vim.cmd.colorscheme('rose-pine-main')
      end,
      update_interval = 100,
      --sunrise_offset = 1800,
      --sunset_offset = -1800,
})
