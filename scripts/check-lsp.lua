-- Run inside headless nvim by check-lsp.sh. Waits for every LSP client named in
-- $EXPECT (comma-separated) to attach to the current buffer, then exits 0, or 1 on failure.
if (vim.env.EXPECT or "") == "" then
  io.stderr:write("EXPECT is not set\n")
  vim.cmd("cquit 1")
end
local want = vim.split(vim.env.EXPECT, ",")
local function names()
  return vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients({ bufnr = 0 }))
end

local ok = vim.wait(tonumber(vim.env.TIMEOUT or "30000"), function()
  return vim.iter(want):all(function(n)
    return vim.tbl_contains(names(), n)
  end)
end, 200)

if vim.env.LENVIM_NIX == "1" and vim.env.PATH:find("mason/bin", 1, true) then
  io.stderr:write("mason/bin is on PATH under the Nix wrapper\n")
  ok = false
end
if vim.env.LENVIM_NIX == "1" then
  for _, c in ipairs(vim.lsp.get_clients()) do
    local cmd = c.config.cmd
    if type(cmd) == "table" then
      local path = vim.fn.exepath(cmd[1])
      if not (vim.startswith(path, "/nix/store/") or vim.startswith(path, "/run/current-system/")) then
        io.stderr:write(c.name .. ": " .. path .. " is not from Nix\n")
        ok = false
      end
    end
  end
end
if not ok then
  io.stderr:write("attached: " .. table.concat(names(), ",") .. "\n")
end
for _, c in ipairs(vim.lsp.get_clients()) do
  c:stop()
end
vim.wait(10000, function()
  return #vim.lsp.get_clients() == 0
end, 100)
for _, c in ipairs(vim.lsp.get_clients()) do
  c:stop(true)
end
vim.cmd(ok and "qa!" or "cquit 1")
