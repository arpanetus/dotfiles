

local status_ok, sunset = pcall(require, "sunset")
if not status_ok then
  vim.notify("sunset doesn't exist", vim.log.levels.ERROR)
  return
end


require('rose-pine').setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'auto',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = true,
	disable_float_background = false,
	disable_italics = false,

	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		background = 'base',
		background_nc = '_experimental_nc',
		panel = 'surface',
		panel_nc = 'base',
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {
		ColorColumn = { bg = 'rose' },

		-- Blend colours against the "base" background
		CursorLine = { bg = 'foam', blend = 10 },
		StatusLine = { fg = 'love', bg = 'love', blend = 10 },
	}
})


vim.cmd.colorscheme('rose-pine')
vim.cmd.colorscheme('rose-pine')


sunset.setup({
      priority = 1000,
      latitude =  43.2389,
      longitude = 76.88,
      day_callback = function()
        vim.cmd.set("background=light")
        -- vim.api.nvim_set_hl(0, "NonText", {ctermbg=NONE})
        -- vim.api.nvim_set_hl(0, "Normal", {guibg=NONE, ctermbg=NONE})
      end,
      night_callback = function()
        vim.cmd.set("background=dark")
        -- vim.api.nvim_set_hl(0, "NonText", {ctermbg=NONE})
        -- vim.api.nvim_set_hl(0, "Normal", {guibg=NONE, ctermbg=NONE})
      end,
      update_interval = 100,
      sunrise_offset = 1800,
      sunset_offset = -1800,
})
