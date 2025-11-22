return {
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        diagnostics = {
          win = {
            type = "split",
            position = "bottom",
            size = 0.3,
          },
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.4,
          },
          -- Enable line wrapping in the diagnostics window
          auto_close = false,
          auto_open = false,
          auto_preview = true,
          auto_refresh = true,
          focus = false,
          restore = true,
          follow = true,
        },
      },
      -- Configure the window to wrap long lines
      win = {
        wo = {
          wrap = true,
          linebreak = true,
          breakindent = true,
        },
      },
    },
  },
}
