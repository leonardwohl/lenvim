-- local checkout: private repo, and global git credential.username is the work account.
-- Only on machines that have the checkout.
local present = vim.uv.fs_stat(vim.fn.expand("~/src/scryvim")) ~= nil

return {
  {
    dir = "~/src/scryvim",
    name = "scryvim",
    cond = present,
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
      if present then
        table.insert(opts.sections.lualine_x, 1, "scryvim")
      end
    end,
  },
}
