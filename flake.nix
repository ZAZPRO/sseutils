{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    packages = builtins.mapAttrs (
      system: pkgs:
      let
        compiler = "${pkgs.gcc}/bin/gcc";
      in
      {
        default = pkgs.mkShellNoCC {
          packages =
            with pkgs;
            let
              clangd = lib.hiPrio (
                pkgsBuildBuild.writeShellScriptBin "clangd" ''
                  ${pkgsBuildBuild.llvmPackages.clang-unwrapped}/bin/clangd --query-driver="${compiler}" "$@"
                ''
              );
            in
            [
              clangd
              gcc
              gdb
              bear
              perf
              nasm
              nasmfmt
              hyperfine
            ];
        };
      }
    ) inputs.nixpkgs.legacyPackages;
  };
}
