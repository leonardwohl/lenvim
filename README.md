# lenvim

My LazyVim config.

## With Nix

`flake.nix` builds nvim with every LSP server, formatter, linter and debug adapter
on its PATH, and Mason turned off. Plugins are still managed by lazy.nvim.

- `nix run .` / `packages.<system>.default`: everything except Java.
- `nix run .#java` / `packages.<system>.java`: adds jdtls, lombok, java-debug/test, sonarlint, checkstyle.

The config itself is read from `~/.config/nvim` as usual, so clone this repo there.
Without the wrapper (plain `nvim`) Mason installs tools as before.

Check that the servers attach: `scripts/check-lsp.sh "$(nix build .#java --print-out-paths --no-link)/bin/nvim" --java`
