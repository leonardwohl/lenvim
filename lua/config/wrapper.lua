-- The Nix wrapper (nix/wrap.nix) sets LENVIM_NIX=1 and puts every tool on PATH.
local M = {}

M.active = vim.env.LENVIM_NIX == "1"

--- Whether a tool's plugin/linter should be configured. Always true without the wrapper:
--- Mason only adds its bin dir to PATH once it loads, after specs are evaluated.
---@param bin string
---@return boolean
function M.has(bin)
  return not M.active or vim.fn.executable(bin) == 1
end

return M
