{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      bat = pkgs.stdenvNoCC.mkDerivation {
        name = "bat";
        src = ./bat;

        nativeBuildInputs = with pkgs; [
          nasm
          mold
        ];

        buildPhase = ''
          nasm --reproducible -f elf64 -g -F dwarf -Ov bat.asm -o bat.o && mold --static -o bat bat.o
        '';

        installPhase = ''
          mkdir -p $out/bin
          mv ./bat $out/bin/
        '';

        meta.mainProgram = "bat";
      };
    }) inputs.nixpkgs.legacyPackages;

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
