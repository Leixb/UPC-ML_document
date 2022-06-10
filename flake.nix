{
  inputs.utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.latex.url = "github:leixb/latex-template";

  outputs = { self, nixpkgs, utils, latex }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        dev-packages = with pkgs; [
          texlab
          zathura
          wmctrl
          which
          python39Packages.pygments
        ];

        SOURCE_DATE_EPOCH = "1654855200"; # 2022-06-10

        texlive = pkgs.texlive.combined.scheme-full;
      in
      rec {
        devShell = pkgs.mkShell {
          inherit SOURCE_DATE_EPOCH;
          name = "texlive";
          buildInputs = [ dev-packages texlive ];
        };

        packages.document = latex.lib.latexmk {
          inherit pkgs texlive SOURCE_DATE_EPOCH;
          src = ./.;
          shellEscape = true;
          minted = true;
          name = "document.pdf";
        };

        defaultPackage = packages.document;
      }
    );
}
