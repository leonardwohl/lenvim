return {
  -- Configure nvim-jdtls for Java development
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              { name = "JavaSE-25", path = "/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home", default = true },
              { name = "JavaSE-21", path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.5-tem" },
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
      },
    },
  },
}
