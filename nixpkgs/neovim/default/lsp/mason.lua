local servers = {
	--"sumneko_lua",
	--"lua_language_server",
  "lua_ls",
  --"luau_ls",
  "jsonls",

  "dockerls",

  "ocamllsp",

  -- "rls",
  "rust_analyzer",

  "gopls",
  "golangci_lint_ls",

  "tsserver",
  "denols",

  "pylsp",
  "pyre",
  "pyright",

  "nil_ls",
  "rnix",
}

local settings = {
	ui = {
		border = "none",
		icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          },
	},
	log_level = vim.log.levels.DEBUG,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("default.lsp.handlers").on_attach,
		capabilities = require("default.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "default.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
