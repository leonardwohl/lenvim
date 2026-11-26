-- Installed from GitHub; machines with a checkout at ~/src/scryvim use it instead
-- (dev = true + dev.fallback in config/lazy.lua).
return {
  {
    "leonardwohl/scryvim",
    dev = true,
    lazy = false, -- plugin/ registers the deck filetype, so ft-based lazy loading can't trigger
    init = function()
      vim.g.scryvim = { type_colors = true, icons = true, pane = { tags = true }, auto_open = true }
    end,
    keys = {
      { "<leader>ms", "<Plug>(scryvim-search)", desc = "Scryvim search" },
      { "<leader>mo", "<Plug>(scryvim-sort)", mode = { "n", "x" }, desc = "Scryvim sort" },
      { "<leader>mp", "<Plug>(scryvim-pane)", desc = "Scryvim pane" },
    },
  },
  {
    -- deck size and mana symbols in deck buffers; empty elsewhere
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, "scryvim")
    end,
  },
}
