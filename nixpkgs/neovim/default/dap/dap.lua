local status_ok, dap = pcall(require, "dap")
if not status_ok then
	vim.notify("nvim-dap doesn't exist", vim.log.levels.ERROR)
	return
end

require("dap").set_log_level("TRACE") -- Helps when configuring DAP, see logs with :DapShowLog

local go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "go",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	{
		type = "go",
		name = "Attach (Pick Process)",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "go",
		name = "Attach (127.0.0.1:9080)",
		mode = "remote",
		request = "attach",
		port = "9080",
	},
}

dap.configurations = { go = go }

dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

require("dap.ext.vscode").load_launchjs(nil, {})

utils = require("default.dap.utils")

for type, _ in pairs(dap.configurations) do
	for _, config in pairs(dap.configurations[type]) do
		if config.envFile then
			local filePath = config.envFile
			for key, fn in pairs(utils.getPlaceholders()) do
				filePath = filePath:gsub(key, fn)
			end

			local f, open_err = io.open(filePath, "r")
			if not f and open_err then
				return nil, open_err
			end

			local parsed_tbl, parsed_err = utils.parseEnvFileString(f:read("*a"))
			f:close()

			if parsed_err then
				vim.notify(parsed_err, vim.log.levels.INFO)
			end

			if parsed_tbl then
				if not config.env then
					config.env = {}
				end

				for k, v in pairs(parsed_tbl) do
					config.env[k] = v
				end
			end

			vim.notify("injected a config from " .. filePath)
		end
	end
end
