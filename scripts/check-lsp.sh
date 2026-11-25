#!/usr/bin/env bash
# Opens one fixture per language in headless nvim and checks the expected LSP clients attach.
# Usage: scripts/check-lsp.sh <path-to-nvim> [--java]
set -uo pipefail
nvim=$(realpath "$1")
root=$(cd "$(dirname "$0")/.." && pwd)
fx=$root/tests/fixtures
fail=0

check() {
  local file=$1 expect=$2 timeout=${3:-30000}
  if (cd "$(dirname "$fx/$file")" && EXPECT=$expect TIMEOUT=$timeout \
    "$nvim" --headless "$fx/$file" "+luafile $root/scripts/check-lsp.lua"); then
    echo "ok   $file -> $expect"
  else
    echo "FAIL $file -> $expect"
    fail=1
  fi
}

check sample.lua lua_ls
check sample.nix nixd
check main.tf terraformls
check .github/workflows/ci.yml yamlls
check sample.py pyright,ruff
check rust/src/main.rs rust-analyzer
check sample.toml taplo
check sample.json jsonls
check Dockerfile dockerls
check sample.sh bashls
if [[ ${2:-} == --java ]]; then
  check java/src/main/java/App.java jdtls,sonarlint.nvim 120000
fi
exit $fail
