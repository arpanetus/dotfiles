local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "default.lsp.mason"
require("default.lsp.handlers").setup()
require "default.lsp.null-ls"
