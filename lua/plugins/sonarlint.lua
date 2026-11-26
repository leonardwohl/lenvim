local wrapper = require("config.wrapper")

return {
  -- Install SonarLint plugin
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    cond = wrapper.has("sonarlint-ls"),
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("sonarlint").setup({
        server = {
          -- nixpkgs' sonarlint-ls already passes -analyzers with every bundled analyzer jar
          cmd = wrapper.active and { "sonarlint-ls", "-stdio" } or {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            -- Core language analyzers
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjavasymbolicexecution.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcsharp.jar"),
            -- Web and markup
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
            -- Additional languages and tools
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonartext.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonariac.jar"),
          },
          settings = {
            sonarlint = {
              -- Enable all rules by default
              rules = {
                ["java:*"] = { level = "on" },
                ["python:*"] = { level = "on" },
                ["cpp:*"] = { level = "on" },
                ["c:*"] = { level = "on" },
              },
              -- Optional: Configure specific rule parameters
              -- Example:
              -- ["java:S1192"] = {
              --   level = "on",
              --   parameters = {
              --     threshold = "3"
              --   }
              -- },
            },
          },
        },
        filetypes = {
          -- Core languages
          "java",
          "python",
          "cs",
          -- Web and markup
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "html",
          "xml",
          -- Additional languages
          "go",
          "php",
          -- Infrastructure as Code
          "terraform",
          "yaml",
          "dockerfile",
        },
      })
    end,
  },

  -- Configure Mason to install SonarLint Language Server
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "sonarlint-language-server",
      },
    },
  },
}
