---
date: '2025-03-09T11:29:39+08:00'
title: '使用 Hugo 与 Nix Flake 来搭建你的博客'
tags: [Nix, Hugo]
categories: [博客日志, 实用程序]
---

其实 Nix 在博客搭建方面并没有完全体现出其优势。但想着可以利用搭博客这个项目来体验下 Nix 的可复现开发环境，就尝试了一下，效果还不错，也就顺便记录一下大概的步骤和遇到的一些问题吧。

## 安装 Nix

这一步其实没什么好说的，Nix 官网有比较详细的教程。主要的问题是 Windows 平台只能通过 WSL 来安装会比较麻烦，Linux 和 MacOS 安装步骤相对比较简单。但需要注意的是，一部分 Linux 发行版安装 Nix 时需要关闭 SeLinux 或者调整其为兼容状态。

- Linux：[安装 Nix](nix.dev/manual/nix/2.17/installation/installation)
- MacOS：[nix-darwin](https://github.com/LnL7/nix-darwin)
- Windows：[NixOS-WSL](https://github.com/nix-community/NixOS-WSL)

对了，其实我更推荐全局代理而不是换源，因为 Nix 很多东西其实是会直接从 GitHub 爬的，换源其实效果不明显。

## 搭建开发环境

新建一个文件夹（我起的名称是 `blog`），在里面新建一个一个名为 `flake.nix` 的文件，我把我的代码贴出来，可以根据自己需求修改：

{{< alert >}}
**注意**：截至文章发布前，`Flake`功能仍然需要手动开启，可以参考 [NixOS Wiki](https://nixos.wiki/wiki/flakes) 。
{{< /alert >}}

```nix
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

```

## Enjoy it

在项目文件夹下输入 `nix develop` 会进入 Nix 的 Bash 环境中，其中都安装好了我们在 Flake 中定义的软件包。不出意外的话，应该能看到这一条 Hook：

```bash
✨ Welcome to the breeze256's blog development shell! ✨
Commands available:
  - nix run .#serve: Start Hugo development server with live reload.
  - nix run .#build: Build the production version of the blog.
  - nix run .#update: Update the blowfish theme to the latest version.
```

在 Shell 中输入：

```bash
nix run .#update
```

它就会自动帮你下载并安装 Blowfish 主题。你可以在 Flake 中定义你自己喜欢的主题，只需要修改下面的几行：

```bash
echo "Updating blowfish theme to the latest version..."
mkdir -p "./themes/blowfish"
API_URL="https://api.github.com/repos/nunocoracao/blowfish/releases/latest"
```

然后，输入 `nix run`，在浏览器中打开输出的 URL，就能够看到渲染效果了。

