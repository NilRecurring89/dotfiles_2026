-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Create a socket for remote control (one per instance)
vim.fn.serverstart(vim.fn.stdpath("run") .. "/nvim." .. vim.fn.getpid() .. ".sock")

-- Clean up socket on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local sock = vim.fn.stdpath("run") .. "/nvim." .. vim.fn.getpid() .. ".sock"
    vim.fn.delete(sock)
  end,
})

-- Global function for matugen color reload
function _G.reload_matugen()
  package.loaded["matugen-colors"] = nil
  local ok, palette = pcall(require, "matugen-colors")
  if ok then
    require("mini.base16").setup({ palette = palette })
  end
end

require("lazy").setup({
  {
    "echasnovski/mini.base16",
    version = false,
    config = function()
      local ok, palette = pcall(require, "matugen-colors")
      if ok then
        require("mini.base16").setup({ palette = palette })
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "lua", "vim", "bash", "python", "javascript", "typescript", "toml", "json" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    },
    config = function()
      require("neo-tree").setup({
        window = { position = "left", width = 30 },
        filesystem = { follow_current_file = { enabled = true } },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
})
