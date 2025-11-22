return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "rcasia/neotest-java",
      "mfussenegger/nvim-dap",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}

      -- Add neotest-java adapter with debug support
      table.insert(
        opts.adapters,
        require("neotest-java")({
          -- Enable ignore_wrapper to use Maven/Gradle directly
          ignore_wrapper = false,
        })
      )

      return opts
    end,
    keys = {
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug Test File",
      },
    },
  },
}
