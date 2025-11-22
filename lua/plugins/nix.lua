return {
  -- Add Nix treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
    end,
  },

  -- Configure Mason to install Nix LSP
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "rnix-lsp",
      },
    },
  },

  -- Configure nvim-lspconfig for Nix
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rnix = {
          settings = {},
        },
      },
    },
  },
}