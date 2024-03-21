local status_ok, comment = pcall(require, "Comment")
if not status_ok then
	vim.notify("Failed to load Comment.nvim", vim.log.levels.ERROR)
	return
end

comment.setup({
	pre_hook = function(ctx)
		local U = require("Comment.utils")
		local status_comment_string_ok, comment_string = pcall(require, "ts_context_commentstring")
		if not status_comment_string_ok then
			return
		end

		comment_string.setup({
			enable_autocmd = false,
		})

		local status_utils_ok, utils = pcall(require, "ts_context_commentstring.utils")
		if not status_utils_ok then
			return
		end

		local location = nil
		if ctx.ctype == U.ctype.block then
			location = utils.get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = utils.get_visual_start_location()
		end

		local status_internals_ok, internals = pcall(require, "ts_context_commentstring.internals")
		if not status_internals_ok then
			return
		end

		return internals.calculate_commentstring({
			key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
			location = location,
		})
	end,
})
