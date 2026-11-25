# External programs the Lua config calls: LSP servers, formatters, linters, debug adapters.
{ pkgs }:
let
  # rustaceanvim looks for `codelldb` on PATH; nixpkgs only ships it inside the VS Code extension.
  codelldb = pkgs.runCommand "codelldb" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
  '';
in
{
  core =
    with pkgs;
    [
      ripgrep
      fd
      fzf
      git
      curl # nvim-treesitter and blink.cmp download with it
      tree-sitter # nvim-treesitter (main branch) compiles parsers with it
      lua-language-server
      stylua
      nixd
      nixfmt
      terraform-ls
      tflint
      yaml-language-server
      actionlint
      prettier
      vscode-langservers-extracted
      taplo
      dockerfile-language-server
      docker-compose-language-service
      hadolint
      pyright
      ruff
      python3Packages.debugpy # provides debugpy-adapter for nvim-dap-python
      rust-analyzer
      codelldb
      bash-language-server
      shfmt
      shellcheck
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gcc ]; # macOS uses Xcode's cc

  # lombok, java-debug and java-test are jars, passed by path in wrap.nix.
  java = with pkgs; [
    jdt-language-server
    sonarlint-ls
    checkstyle
  ];
}
