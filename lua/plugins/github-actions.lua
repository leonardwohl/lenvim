return {
  -- Add GitHub Actions treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "yaml" })
    end,
  },

  -- Configure Mason to install GitHub Actions LSP and formatter
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "actionlint",
        "yaml-language-server",
        "prettier",
      },
    },
  },

  -- Configure nvim-lspconfig for YAML/GitHub Actions
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },

  -- Configure formatting for YAML files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "prettier" },
      },
    },
  },
}