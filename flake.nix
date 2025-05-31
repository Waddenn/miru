{
  description = "Miru - Stream anime torrents in real-time";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"] (system:
        f {
          inherit system;
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forAllSystems ({pkgs, ...}: {
      miru = pkgs.callPackage ./package.nix {};
    });

    apps = forAllSystems ({
      pkgs,
      system,
      ...
    }: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/miru";
      };
    });

    devShells = forAllSystems ({pkgs, ...}: {
      default = pkgs.mkShell {
        buildInputs = [pkgs.nodejs pkgs.yarn];
      };
    });
  };
}
