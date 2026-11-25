-- Under the Nix wrapper every tool comes from PATH, so Mason stays off.
-- Without the wrapper Mason works as usual.
local wrapper = require("config.wrapper")

return {
  { "mason-org/mason.nvim", enabled = not wrapper.active },
  { "mason-org/mason-lspconfig.nvim", enabled = not wrapper.active },
  { "jay-babu/mason-nvim-dap.nvim", enabled = not wrapper.active },
}
