{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    packages =
      let
        system = "x86_64-linux";
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        mkasm =
          path: name:
          pkgs.stdenvNoCC.mkDerivation {
            inherit name;
            src = ./.;

            nativeBuildInputs = with pkgs; [
              nasm
              mold
            ];

            buildPhase = ''
              nasm --reproducible -Ilib -f elf64 -g -F dwarf -Ov ${path}/${name}.asm -o ${name}.o && mold --static -o ${name}.elf ${name}.o
            '';

            installPhase = ''
              mkdir -p $out/bin
              mv ./${name}.elf $out/bin/${name}
            '';

            meta.mainProgram = name;
          };

      in
      {
        ${system} = {
          bat = mkasm "bat" "bat";
          poweroff = mkasm "power" "poweroff";
        };
      };

    devShells = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          mold
          gdb
          perf
          nasm
          nasmfmt
          hyperfine
        ];
      };
    }) inputs.nixpkgs.legacyPackages;

  };
}
