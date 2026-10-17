{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    packages =
      let
        system = "x86_64-linux";
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        ${system} = {
          bat = pkgs.stdenvNoCC.mkDerivation {
            name = "bat";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              nasm
              mold
            ];

            buildPhase = ''
              nasm --reproducible -Ilib -f elf64 -g -F dwarf -Ov bat/bat.asm -o bat.o && mold --static -o bat.elf bat.o
            '';

            installPhase = ''
              mkdir -p $out/bin
              mv ./bat.elf $out/bin/bat
            '';

            meta.mainProgram = "bat";
          };

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
