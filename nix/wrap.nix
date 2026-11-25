# nvim with the tools from tools.nix on PATH. The Lua config still comes from ~/.config/nvim.
{ pkgs, java }:
let
  inherit (pkgs) lib;
  tools = import ./tools.nix { inherit pkgs; };
  vscjava = pkgs.vscode-extensions.vscjava;
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  wrapRc = false;
  wrapperArgs = [
    # suffix, so a project's devshell tools (its own JDK, rust-analyzer, ...) win
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath (tools.core ++ lib.optionals java tools.java))
    "--set"
    "LENVIM_NIX"
    "1"
  ]
  ++ lib.optionals java [
    "--set"
    "LENVIM_LOMBOK_JAR"
    "${pkgs.lombok}/share/java/lombok.jar"
    "--set"
    "LENVIM_JAVA_DEBUG_DIR"
    "${vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server"
    "--set"
    "LENVIM_JAVA_TEST_DIR"
    "${vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server"
  ];
}
