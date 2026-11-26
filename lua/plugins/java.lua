local wrapper = require("config.wrapper")

return {
  -- Configure nvim-jdtls for Java development
  {
    "mfussenegger/nvim-jdtls",
    -- the Nix wrapper's default variant has no jdtls; don't try to start it there
    cond = wrapper.has("jdtls"),
    opts = function(_, opts)
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-25",
                path = vim.env.JDK25_HOME or "/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home",
                default = true,
              },
              {
                name = "JavaSE-21",
                path = vim.env.JDK21_HOME or "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.5-tem",
              },
            },
          },
          -- Sort imports lexicographically (alphabetically)
          -- Empty importOrder array means fully alphabetical sorting
          completion = {
            importOrder = {},
          },
          sources = {
            organizeImports = {
              starThreshold = 99,
              staticStarThreshold = 99,
            },
          },
        },
      })

      -- LazyVim's java extra only adds lombok and the java-debug/java-test bundles when
      -- Mason is loaded. Under the Nix wrapper, add them from the jars it points at.
      if vim.env.LENVIM_LOMBOK_JAR then
        table.insert(opts.cmd, "--jvm-arg=-javaagent:" .. vim.env.LENVIM_LOMBOK_JAR)
      end
      if vim.env.LENVIM_JAVA_DEBUG_DIR then
        opts.jdtls = vim.tbl_deep_extend("force", opts.jdtls or {}, {
          init_options = {
            bundles = vim.list_extend(
              vim.fn.glob(vim.env.LENVIM_JAVA_DEBUG_DIR .. "/com.microsoft.java.debug.plugin-*.jar", false, true),
              vim.fn.glob(vim.env.LENVIM_JAVA_TEST_DIR .. "/*.jar", false, true)
            ),
          },
        })
        local on_attach = opts.on_attach
        opts.on_attach = function(args)
          require("jdtls").setup_dap(opts.dap)
          require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
          if on_attach then
            on_attach(args)
          end
        end
      end
    end,
  },
}
