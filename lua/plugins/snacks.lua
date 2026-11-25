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
      -- Make picker case insensitive
      picker = {
        matcher = {
          ignorecase = true,
          smartcase = false,
        },
        formatters = {
          file = {
            min_width = 80,
          },
        },
        on_change = function(picker, item)
          local win = picker.preview and picker.preview.win
          if not (win and win:valid()) then return end
          local path = item and item.file and Snacks.picker.util.path(item)
          vim.wo[win.win].winbar = path and vim.fn.fnamemodify(path, ":~:.") or ""
        end,
      },
    },
  },
}
