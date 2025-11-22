return {
  -- Configure nvim-jdtls for Java development
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
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
