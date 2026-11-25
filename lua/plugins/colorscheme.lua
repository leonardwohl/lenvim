return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = { term_colors = true },
  },

  -- Disable bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- a flavour name: plain "catppuccin" resolves to Neovim 0.12's bundled, minimal port
      colorscheme = "catppuccin-mocha",
    },
  },
}