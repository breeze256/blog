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
            echo "  - nix run .#update: Update the blowfish theme to the latest version."
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
          update = {
            type = "app";
            program = "${self.packages.${system}.blowfish-update}/bin/blowfish-update";
            description = "Update the blowfish theme to the latest version.";
          };
        };

        packages = {
          hugo-serve = pkgs.writeShellScriptBin "hugo-serve" ''
            #!/usr/bin/env bash
            set -euo pipefail

            echo "Hugo development server starting with live reload... "
            # Hugo 内置 Live Reload 功能
            hugo server --bind=0.0.0.0 --baseURL=http://localhost:1313 --disableFastRender --watch --buildDrafts
            echo " Hugo development server stopped. "
          '';

          hugo-build = pkgs.writeShellScriptBin "hugo-build" ''
            #!/usr/bin/env bash
            set -euo pipefail

            echo "Building production version of the Hugo blog... "
            hugo "$@" --minify
            echo "Production build completed! 🎉"
          '';

          blowfish-update = pkgs.writeShellScriptBin "blowfish-update" ''
            #!/usr/bin/env bash

            echo "Updating blowfish theme to the latest version..."
            mkdir -p "./themes/blowfish"
            API_URL="https://api.github.com/repos/nunocoracao/blowfish/releases/latest"

            RELEASE_INFO=$(curl -s "$API_URL")
            TARBALL_URL=$(echo "$RELEASE_INFO" | jq -r '.tarball_url')

            if [[ -z "$TARBALL_URL" ]]; then
                echo "Error: Could not find tar.gz release source code."
                exit 1
            fi

            FILENAME=$(basename "$TARBALL_URL")
            ARCHIVE_FILE="$FILENAME"

            curl -L -o "$ARCHIVE_FILE" "$TARBALL_URL" || { echo "Error: Download failed."; exit 1; }
            tar --strip-components=1 -xzf "$ARCHIVE_FILE" -C "./themes/blowfish" || { echo "Error: Extraction failed."; exit 1; }
            rm "$ARCHIVE_FILE" || echo "Warning: Delete archive failed."
            echo "The theme was updated successfully! 🎉"
          '';
        };
      });
}
