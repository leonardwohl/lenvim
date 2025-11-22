-- Disable LSP progress notifications
vim.lsp.handlers["$/progress"] = function() end

-- Configure how inline diagnostics are displayed
vim.diagnostic.config({
  virtual_text = {
    -- Wrap long diagnostic messages
    wrap = true,
    -- Or alternatively, show only the first line and truncate
    -- format = function(diagnostic)
    --   return string.sub(diagnostic.message, 1, 80)
    -- end,
  },
  float = {
    -- Enable wrapping in floating diagnostic windows (on hover)
    wrap = true,
    wrap_at = 80,
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Optional: Show full diagnostic in floating window on cursor hold
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    })
  end,
})
