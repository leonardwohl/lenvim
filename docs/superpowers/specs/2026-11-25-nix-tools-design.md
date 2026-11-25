# lenvim on Nix: tools from Nix, plugins from lazy.nvim

## Purpose

Run this Neovim config on the Mac (nix-darwin, `~/.config/nix`) and on the two
NixOS hosts, jenny and babel (`/Volumes/code/nix-homelab`). Mason-installed
binaries don't work on NixOS, so Nix supplies every external tool instead.
lazy.nvim still downloads and manages plugins, pinned by `lazy-lock.json`.

Out of scope: Nix-built plugins, nixvim, home-manager.

## Constraints

- No pushes to GitHub. All work goes on local branches. The user publishes
  lenvim (it is private today) and pushes when ready.
- homelab hosts run `homelab-auto-deploy` (root, `nixos-rebuild` from
  origin/master), so lenvim must be fetchable as `github:leonardwohl/lenvim`
  before the homelab change is merged. Until lenvim is public, the homelab change
  is only verified by evaluating with `--override-input`.

## 1. lenvim flake

New `flake.nix` at the repo root.

- Input: `nixpkgs` (nixpkgs-unstable). Consumers set `inputs.nixpkgs.follows`.
- Systems: `aarch64-darwin`, `x86_64-linux`.
- Outputs:
  - `packages.<system>.default`: nvim wrapped with the core tools.
  - `packages.<system>.java`: the core tools plus the Java stack.
- The wrapper is `pkgs.neovim` with extra makeWrapper args:
  - `--suffix PATH : <tools>`. Suffix, so a project's devshell tools win.
  - `--set LENVIM_NIX 1`.
  - `java` variant only:
    - `LENVIM_LOMBOK_JAR`: lombok.jar
    - `LENVIM_JAVA_DEBUG_DIR`: directory holding `com.microsoft.java.debug.plugin-*.jar`
    - `LENVIM_JAVA_TEST_DIR`: directory holding the java-test server jars
  - No sonarlint variable is needed: nixpkgs' `sonarlint-ls` wrapper already
    passes `-analyzers` with every bundled analyzer jar.
- The tool lists live in `nix/tools.nix`, which returns `{ core, java }`. All
  attribute names below were checked against the darwin flake's nixpkgs pin on
  2026-11-25.
  - core: `ripgrep fd fzf git curl tree-sitter lua-language-server stylua nixd
    nixfmt terraform-ls tflint yaml-language-server actionlint prettier
    vscode-langservers-extracted taplo dockerfile-language-server
    docker-compose-language-service hadolint pyright ruff
    python3Packages.debugpy rust-analyzer bash-language-server shfmt
    shellcheck`, a `codelldb` shim, and `gcc` on Linux only.
    - `curl` is what nvim-treesitter and blink.cmp download with.
    - `gcc` is for Treesitter parser compilation (macOS uses Xcode's `cc`).
    - `python3Packages.debugpy` provides `debugpy-adapter`, which nvim-dap-python
      calls.
    - The `codelldb` shim is a `bin/codelldb` symlink to `vscode-lldb`'s
      `adapter/codelldb`. rustaceanvim finds `codelldb` on PATH.
  - java (on PATH): `jdt-language-server sonarlint-ls checkstyle`. lombok,
    java-debug and java-test are jars, so they are passed through the env
    vars above.

## 2. Lua changes

Everything must keep working when nvim runs **without** the wrapper. In that
case `LENVIM_NIX` is unset and Mason behaves as it does today.

- `lua/plugins/nix.lua`:
  - When `vim.env.LENVIM_NIX` is set, disable `mason-org/mason.nvim`,
    `mason-org/mason-lspconfig.nvim` and `jay-babu/mason-nvim-dap.nvim`.
  - Replace `rnix` and the `rnix-lsp` Mason entry with `nixd`.
- `lua/plugins/sonarlint.lua`:
  - Under the wrapper the command is `{ "sonarlint-ls", "-stdio" }`. Without
    the wrapper it stays `sonarlint-language-server` with the `$MASON` analyzer
    jars, as today.
  - Under the wrapper, skip it when `sonarlint-ls` isn't executable.
- `lua/plugins/java.lua`:
  - With Mason disabled, LazyVim's java extra adds no lombok agent, no
    debug/test bundles and no main-class DAP configs. When the `LENVIM_*` Java
    vars are set, add all three from them. This means overriding
    `opts.full_cmd` (lombok), `opts.jdtls.init_options.bundles`, and an
    on-attach that calls `require("jdtls.dap").setup_dap_main_class_configs()`.
  - JDK runtime paths come from `JDK25_HOME`/`JDK21_HOME` when set, otherwise
    from the current hardcoded macOS paths.
  - When `jdtls` is not executable (the `default` variant), disable
    `nvim-jdtls` so opening a Java file doesn't error.
- `lua/plugins/checkstyle.lua`: under the wrapper, only register the
  `checkstyle` linter when the binary is executable. (`tflint` is always in
  core, so `terraform.lua` needs no guard.)
- Guards apply only under the wrapper. Without it, Mason puts its bin dir on
  PATH only when it loads, after the specs are evaluated, so a startup
  `executable()` check would wrongly disable tools.
- `lua/plugins/scryvim.lua`: add `cond` so it only loads when `~/src/scryvim`
  exists. The lualine component is only added under the same condition.
- Treesitter stays as it is: parsers compile at runtime using the
  `tree-sitter` and `cc` from PATH.
- Known risk: blink.cmp downloads a prebuilt Rust matcher. If it fails to load
  on NixOS, blink falls back to its Lua matcher. That is acceptable, and the
  host checks will show whether it happens.

## 3. Consumers

### Darwin (`~/.config/nix/flake.nix`)

- Add the input `lenvim.url = "git+file:///Users/lenwohl/.config/nvim"` with
  `inputs.nixpkgs.follows = "nixpkgs"`.
  - Use `git+file:`, not `path:` like `mcbuild`. A `path:` input fails with a
    hash mismatch whenever lazy-lock.json changes. `git+file:` locks a commit,
    and picking up changes takes `nix flake update lenvim`.
- Replace `pkgs.neovim` in `environment.systemPackages` with
  `lenvim.packages.${system}.java`.
- Remove the neovim overlay. Its `overrideAttrs` attributes do nothing.
- Add `environment.variables.EDITOR = "nvim"`.

### Homelab (`/Volumes/code/nix-homelab`)

- `flake.nix`: add the input `lenvim.url = "github:leonardwohl/lenvim"` with
  `inputs.nixpkgs.follows = "nixpkgs"`. `inputs` already reaches modules
  through `specialArgs`.
- `modules/base/shell.nix`:
  - Remove `programs.neovim`. It wraps `programs.neovim.package` again and
    expects an unwrapped neovim.
  - Add `inputs.lenvim.packages.${pkgs.stdenv.hostPlatform.system}.default`
    to `environment.systemPackages`.
  - Set `environment.variables.EDITOR = "nvim"`.
- The homelab commit can't include a `flake.lock` entry for lenvim until lenvim
  is public. Before merging, the user runs `nix flake update lenvim` and
  commits the lock.
- One-time manual step on each host: `git clone` lenvim into `~/.config/nvim`.

## 4. Testing

- lenvim:
  - `nix flake check`.
  - `nix build .#default .#java`.
  - A headless check script (`scripts/check-lsp.sh`) runs the built nvim.
    - For each language it opens a sample file, waits, and prints the
      attached LSP clients:
      - lua → lua_ls
      - nix → nixd
      - `.tf` → terraformls
      - `.github/workflows/*.yml` → yamlls
      - `.py` → pyright, ruff
      - `.rs` → rust-analyzer
      - `.toml` → taplo
      - `.json` → jsonls
      - `Dockerfile` → dockerls
    - On `java` it also checks `.java` → jdtls.
    - It fails if an expected client is missing.
    - It also checks that no Mason bin directory is on `PATH`.
- Darwin: `darwin-rebuild build --flake ~/.config/nix`. The user runs the
  switch.
- Homelab:
  - `nix eval` of each host's `environment.systemPackages` names,
    `environment.variables.EDITOR` and `programs.neovim.enable`, with
    `--override-input lenvim git+file:///Users/lenwohl/.config/nvim`.
  - The full toplevel isn't evaluated: babel's uv2nix inputs may need
    Linux builds during evaluation.
  - The real build and use happen on the hosts once lenvim is pushed.

## 5. Git

- lenvim:
  - The user's WIP was committed on `main` (dc15bbd).
  - The work happens on the `nix-tools` branch.
- nix-darwin and homelab: a local branch each.
- Nothing is pushed.
