return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = { ensure_installed = { "java-debug-adapter" } },
    },
  },
  opts = function()
    local dap = require("dap")

    -- Quarkus Java DAP Configuration for Web Asset Release Service
    dap.configurations.java = vim.list_extend(dap.configurations.java or {}, {
      -- Direct launch of Quarkus dev mode
      {
        type = "java",
        request = "launch",
        name = "🚀 Launch Quarkus Dev Mode (Direct)",
        -- Use the Maven wrapper to start Quarkus dev mode
        program = "./mvnw",
        args = {
          "compile",
          "quarkus:dev",
          "-Ddebug=false", -- We're debugging directly, not remote
        },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        stopOnEntry = false,
        -- Quarkus-specific environment
        env = {
          MAVEN_OPTS = "--enable-preview -Xmx2g",
        },
      },

      -- Direct launch with debug suspend (waits for debugger)
      {
        type = "java",
        request = "launch",
        name = "🔄 Launch Quarkus Dev Mode (Debug Suspend)",
        program = "./mvnw",
        args = {
          "compile",
          "quarkus:dev",
          "-Ddebug=5005",
          "-Dsuspend=y",
        },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        stopOnEntry = false,
        env = {
          MAVEN_OPTS = "--enable-preview -Xmx2g",
        },
      },

      -- Launch the generated JAR directly (after build)
      {
        type = "java",
        request = "launch",
        name = "📦 Launch Quarkus JAR (Direct)",
        -- Run the generated quarkus application JAR
        program = "java",
        args = {
          "--enable-preview",
          "-Djava.util.logging.manager=org.jboss.logmanager.LogManager",
          "-Dquarkus.http.host=0.0.0.0",
          "-Dquarkus.http.port=8080",
          "-jar",
          "target/quarkus-app/quarkus-run.jar",
        },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        stopOnEntry = false,
      },

      -- Remote attach (for when you start quarkus:dev with debug separately)
      {
        type = "java",
        request = "attach",
        name = "🔌 Attach to Quarkus Dev Mode",
        hostName = "127.0.0.1",
        port = 5005,
        projectName = "webAssetReleaseService",
      },
    })

    -- Add custom keymaps for Quarkus debugging
    vim.keymap.set("n", "<leader>dq", function()
      -- Quick launch attach to Quarkus
      dap.run(vim.tbl_filter(function(config)
        return config.name == "🔌 Attach to Quarkus Dev Mode"
      end, dap.configurations.java)[1])
    end, { desc = "Debug: Attach to Quarkus" })

    vim.keymap.set("n", "<leader>dQ", function()
      -- Launch Quarkus in debug suspend mode
      dap.run(vim.tbl_filter(function(config)
        return config.name == "🔄 Launch Quarkus Dev Mode (Debug Suspend)"
      end, dap.configurations.java)[1])
    end, { desc = "Debug: Launch Quarkus (Suspend)" })

    -- Helper function to start Quarkus in debug mode via terminal
    vim.keymap.set("n", "<leader>qs", function()
      vim.cmd("split")
      vim.cmd("terminal ./mvnw compile quarkus:dev -Ddebug=5005")
    end, { desc = "Start Quarkus in Debug Mode" })

    -- Helper function to start Quarkus normally via terminal
    vim.keymap.set("n", "<leader>qr", function()
      vim.cmd("split")
      vim.cmd("terminal ./mvnw compile quarkus:dev")
    end, { desc = "Start Quarkus Dev Mode" })
  end,
}

