{
  description = "Len's LazyVim config, with its LSP servers and tools provided by Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ] (
          system: f nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = eachSystem (pkgs: {
        default = import ./nix/wrap.nix {
          inherit pkgs;
          java = false;
        };
        java = import ./nix/wrap.nix {
          inherit pkgs;
          java = true;
        };
      });
    };
}
