-- TODO: move all the configs (plugins, configs per plugin, etc) into neovim.nix

-- Automatically install packer
-- local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
-- if fn.empty(fn.glob(install_path)) > 0 then
-- PACKER_BOOTSTRAP = fn.system {
-- "git",
-- "clone",
-- "--depth",
-- "1",
-- "https://github.com/wbthomason/packer.nvim",
-- install_path,
-- }
-- print "Installing packer close and reopen Neovim..."
-- vim.cmd [[packadd packer.nvim]]
-- end

-- Autocommand that reloads neovim whenever you save the plugins.lua file.
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use.
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  -- use "wbthomason/packer.nvim" -- No need, since nix handles it.
  use "nvim-lua/popup.nvim"                                                                -- An implementation of the Popup API from vim in Neovim.
  use "nvim-lua/plenary.nvim"                                                              -- Useful lua functions used ny lots of plugins.
  use { "tpope/vim-dispatch", opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } } -- Dispatch like nohup?
  use { "iamcco/markdown-preview.nvim", opt = true, cmd = 'MarkdownPreview' }              -- Markdown Preview, sideloading via nix.
  use { "andymass/vim-matchup", event = "VimEnter" }                                       -- No idea.
  -- use {"terrortylor/nvim-comment", opt=true, event="VimEnter", cmd = {'commentstring'}} -- TODO: learn how to use this.
  use "numToStr/Comment.nvim"                                                              -- Commenting plugin.
  use "windwp/nvim-autopairs"                                                              -- Autopairs.
  use "kyazdani42/nvim-web-devicons"                                                       -- Icons for nvim.
  use "kyazdani42/nvim-tree.lua"                                                           -- File explorer.

  -- Colorscheme.
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  use({
    "JManch/sunset.nvim",
    after = { "rose-pine" },
    as = "sunset",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("default.colours")
      end, 100)
    end
  })

  -- Code completion plugins.
  use "hrsh7th/nvim-cmp"                    -- The completion plugin.
  use "hrsh7th/cmp-buffer"                  -- Buffer completions.
  use "hrsh7th/cmp-path"                    -- Path completions.
  use "hrsh7th/cmp-cmdline"                 -- Command line completions.
  use "saadparwaiz1/cmp_luasnip"            -- Snippet completions.
  use { "mtoohey31/cmp-fish", ft = "fish" } -- Fish completions.
  use "hrsh7th/cmp-nvim-lsp"                -- LSP Completions.
  use "hrsh7th/cmp-nvim-lua"                -- LSP Completions for Neovim.

  -- use {"github/copilot.vim", cmd = "Copilot"} -- Needed for the auth.

  local copilot_status_ok, _ = pcall(require, "copilot")
  if copilot_status_ok then
    use {
      "zbirenbaum/copilot-cmp",
      after = { "nvim-cmp" },
      config = function()
        vim.defer_fn(function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end, 100)
        require("copilot_cmp").setup()
      end
    } -- Copilot completions.
  else
    vim.notify("can't find the copilot.lua!")
  end

  -- Snippets.
  use "L3MON4D3/LuaSnip"                  -- Snippet engine.
  use "rafamadriz/friendly-snippets"      -- A bunch of snippets to use.

  use "neovim/nvim-lspconfig"             -- Enable LSP.
  use "williamboman/mason.nvim"           -- Simple to use language server installer.
  use "williamboman/mason-lspconfig.nvim" -- LSP config for Mason.
  use "jose-elias-alvarez/null-ls.nvim"   -- LSP diagnostics and code actions.

  -- Telescope.
  use "nvim-telescope/telescope.nvim"
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  -- Ueberzug is not maintained.
  -- use "nvim-telescope/telescope-media-files.nvim"

  -- Treesitter.
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "p00f/nvim-ts-rainbow"                        -- Rainbow parentheses.
  use "nvim-treesitter/playground"                  -- Treesitter playground.
  use "JoosepAlviste/nvim-ts-context-commentstring" -- Treesitter context commentstring."


  -- Git.
  use "lewis6991/gitsigns.nvim"

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  ---@diagnostic disable-next-line: undefined-global
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
