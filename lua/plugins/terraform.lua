return {
  -- Add Terraform treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "terraform", "hcl" })
    end,
  },

  -- Configure Mason to install Terraform LSP and formatter
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "terraform-ls",
        "tflint",
      },
    },
  },

  -- Configure nvim-lspconfig for Terraform
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          settings = {
            terraform = {
              completion = {
                enable = true,
              },
              validation = {
                enable = true,
              },
            },
          },
        },
        -- Explicitly disable tflint as an LSP (it's a linter, not an LSP)
        tflint = {
          enabled = false,
        },
      },
    },
  },

  -- Configure formatting for Terraform files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },

  -- Configure linting for Terraform files
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },
}