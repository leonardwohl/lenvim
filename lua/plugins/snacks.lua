return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Disable LSP progress notifications completely
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      -- This is the key setting - disable LSP progress notifications
      progress = {
        enabled = false,
      },
      -- Disable scroll animation
      scroll = { enabled = false },
    },
  },
}
