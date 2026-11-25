return {
  -- Add Nix treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
    end,
  },

  -- nixd comes from PATH (Nix wrapper, or nix-darwin systemPackages)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {},
      },
    },
  },
}
