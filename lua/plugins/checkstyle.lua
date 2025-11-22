return {
  -- Configure nvim-lint to use checkstyle
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    opts = {
      linters_by_ft = {
        java = { "checkstyle" },
      },
    },
  },

  -- Configure Mason to install checkstyle
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "checkstyle",
      },
    },
  },
}
