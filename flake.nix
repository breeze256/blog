{
  description = "Flake for breeze256's blog.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.hugo
          ];

          # 友好的 shellHook 提示
          shellHook = ''
            echo "✨ Welcome to the breeze256's blog development shell! ✨"
            echo "Commands available:"
            echo "  - nix run .#serve: Start Hugo development server with live reload."
            echo "  - nix run .#build: Build the production version of the blog."
          '';
        };
        
        # 常用的便捷指令
        apps = {
          default = self.apps.${system}.serve; # 默认 app 设置为 serve 命令，更常用
          serve = {
            type = "app";
            program = "${self.packages.${system}.hugo-serve}/bin/hugo-serve";
            description = "Start Hugo development server with live reload."; # 描述信息
          };
          build = {
            type = "app";
            program = "${self.packages.${system}.hugo-build}/bin/hugo-build";
            description = "Build the production version of the blog.";
          };
        };

        packages = {
          hugo-serve = pkgs.writeShellScriptBin "hugo-serve" ''
            #!/usr/bin/env bash
            set -euo pipefail

            echo "Hugo development server starting with live reload... "
            # Hugo 内置 Live Reload 功能
            hugo server --bind=0.0.0.0 --baseURL=http://localhost:1313 --disableFastRender --watch
            echo " Hugo development server stopped. "
          '';

          hugo-build = pkgs.writeShellScriptBin "hugo-build" ''
            #!/usr/bin/env bash
            set -euo pipefail

            echo "Building production version of the Hugo blog... "
            hugo "$@" --minify
            echo "Production build completed! 🎉"
          '';
        };
      });
}
