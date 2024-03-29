local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify "Error: nvim-tree not found"
  return
end

-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
--   vim.notify "Error: nvim-tree config not found"
--   return
-- end

---@diagnostic disable-next-line: unused-local
-- local tree_cb = nvim_tree_config.nvim_tree_callback

local attach_status_ok, nvim_tree_on_attach = pcall(require, "default.ntratch")
if not attach_status_ok then
  vim.notify "Error: nvim-tree on_attach not found"
  return
end

nvim_tree.setup {
  on_attach = nvim_tree_on_attach,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  -- Since it's deprecated to use it. I'll leave it as a reference.
  -- `on_attach` already does the required job.
  view = {
    width = 30,
    --   height = 30,  -- What the actual???
    side = "left",
    -- mappings = {
    --   list = {
    --     { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
    --     { key = "h", cb = tree_cb "close_node" },
    --     { key = "v", cb = tree_cb "vsplit" },
    --   },
    -- },
  },
}
