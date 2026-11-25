return {
  {
    -- local checkout: private repo, and global git credential.username is the work account
    dir = "~/src/scryvim",
    name = "scryvim",
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
