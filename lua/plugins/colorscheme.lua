return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },

  -- Disable bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}