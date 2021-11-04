{
  description = "A neovim plugin for lean";

  inputs = {

    nixpkgs.url = github:nixos/nixpkgs/nixos-21.05;
    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      name = "lean.nvim";
      inherit (pkgs.vimUtils) buildVimPlugin;
      plugin = buildVimPlugin {
        pname = name;
        version = "2020-11-04";
        src = ./.;
        buildInputs = [ pkgs.neovim ];
      };
    in
    {
      packages = {
        ${name} = plugin;
      };

      defaultPackage = self.packages.${system}.${name};

      devShell = pkgs.mkShell {
        buildInputs = [ ];
      };
    });
}
