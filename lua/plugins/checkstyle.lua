local wrapper = require("config.wrapper")

return {
  -- Configure nvim-lint to use checkstyle (the Nix wrapper's default variant has none)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    opts = {
      linters_by_ft = {
        java = wrapper.has("checkstyle") and { "checkstyle" } or nil,
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
