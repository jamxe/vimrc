# 小彭老师自用 NeoVim 整合包

本整合包内含大量实用插件，包括智能补全、语法高亮、错误提示、快速跳转、全局搜索、集成终端、文件浏览、Git 支持等。且安装方便，小彭老师自用同款，纯 Lua 配置，是您基于 NeoVim 的 IDE 不二之选。

## 一键安装（推荐）

无需克隆本仓库，直接在命令行中输入以下命令即可安装：

```bash
curl -sSLf https://142857.red/files/nvimrc-install.sh | bash
```

如果安装遇到问题，欢迎通过 [GitHub issue](github.com/archibate/vimrc/issues) 反映，我会尽快帮您解决。

* 目前只支持 Linux 系统，暂时不支持 MacOS 等系统。
* 请勿以 root 身份运行！否则会为 root 安装 nvim 插件而不是当前用户，插件安装后仅对当前用户有效。
* 您的系统中无需事先安装有 nvim，本整合包内部已经自带了最新版 nvim 的 AppImage，可无依赖直接运行。
* 无需连接 GitHub，所有插件全部已经预下载在整合包内部，无需 GitHub 加速器！
* 过程中会通过您系统的包管理器安装一些工具，所以只需确保包管理器的设置是国内源即可。
* 为了能够使用补全，会为您安装如 clangd 一类的包，但即使其中一个安装失败，也不影响其他语言和编辑器整体的使用。
* 安装脚本运行中可能产生一些冗余错误信息，属于正常现象，不影响使用，请忽视他们。

安装完成后，输入 `nvim` 即可使用，按 q 或 :wqa 即可退出。

如需更新，重新执行上面的一键安装命令即可。

推荐为您的终端安装 [Nerd Font](https://www.cnblogs.com/zi-wang/p/12566898.html) 字体，并把终端设置为该字体。然后在 `nvim` 中输入 `:lua require'archvim.options'.nerd_fonts = true`，这样就可以显示文件类型图标了。

> 小彭老师用的是 JetBrainsMono Nerd Font Regular，字号 16，这是一款专为程序员打造的等宽字体。

如需自己定制插件参数、移除不想要的插件或添加更多插件：可以编辑 `~/.config/nvim/lua/archvim/plugins.lua`，里面有全部的插件列表，删除或添加即可。

> 注意：删除或添加了新插件后，需要运行 `:PackerSync` 和 `:PackerCompile` 命令才能生效。

### 常见问题

- Q: 不想要部分插件，或想安装其他插件？
- A: 修改 [`~/.config/nvim/lua/archvim/plugins.lua`](lua/archvim/plugins.lua) 中的 `plugins` 列表即可。

- Q: 不想要部分 LSP 服务器？
- A: 修改 [`~/.config/nvim/lua/archvim/config/mason.lua`](lua/archvim/config/mason.lua) 中的 `ensure_installed` 字段即可。

- Q: 不想要部分语法高亮？
- A: 修改 [`~/.config/nvim/lua/archvim/config/tree-sitter.lua`](lua/archvim/config/tree-sitter.lua) 中的 `ensure_installed` 字段即可。

- Q: 出现乱码，无法正确显示符号？
- A: 安装 [Nerd Font](https://www.cnblogs.com/zi-wang/p/12566898.html) 字体，并把终端设置为该字体。然后在 `nvim` 中输入 `:lua require'archvim.options'.nerd_fonts = true`，重启，这样以后就可以正确显示文件类型图标了。如果不喜欢，那就 `:lua require'archvim.options'.nerd_fonts = false` 关闭。

- Q: 编辑 C/C++ 源码时不识别头文件目录，“飙红线”，怎么办？
- A: 要么在 NeoVim 中用 `:CMakeGenerate` 命令，要么给 `cmake` 指定 `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` 参数，详见下方的 “C/C++/CMake 配置” 章节。

- Q: 支持（非 Neo 的）Vim 吗？
- A: 本分支只有 NeoVim 配置，对于来自 BV1H44y1V7DW 视频想领取老版 Vim 插件的同学，请移步 [main 分支](https://github.com/archibate/vimrc/tree/main)。

### 支持的 Linux 发行版

- Arch Linux（亲测可用）
- Manjano Linux (群友测试可用)
- Ubuntu (亲测 20.04 可用)
- Debian (理论可行，没有测试过)
- Kali Linux (理论可行，没有测试过)
- Raspbian (理论可行，没有测试过)
- Fedora (感谢 @justiceeem 大佬)
- OpenSUSE (感谢 @sleeplessai 大佬)
- CentOS (感谢 @xxy-im 大佬)
- Deepin (感谢 @zhangasia 大佬)
- MacOS (感谢 @YangZ2020 测试)

### C/C++/CMake 配置

建议使用本插件自带的 `cmake-tools` 插件的 `:CMakeGenerate` 和 `:CMakeBuild` 命令。

这样是无需任何配置，所有 `CMakeLists.txt` 中配置的头文件都能找得到，语法高亮和代码提示就是正确的。

如果你是 CMake 项目，但想要手动构建，那么请指定 `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` 参数：

```bash
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

这会生成对 C++ 代码补全插件必不可少的 `build/compile_commands.json` 文件。

否则本插件的语法高亮和代码提示插件将无法确定编译的参数，头文件的路径，可能无法正常工作（俗称“飙红线”）。

如果你用的是其他构建系统，可能需要自己在项目根目录下生成 `compile_commands.json` 文件。

如需指定没有 `compile_commands.json` 时默认的 Clangd 选项（单文件编译的情况），编辑文件 [`~/.config/clangd/config.yaml`](dotfiles/.config-clangd-config.yaml)，内容为：

```yaml
CompileFlags:
  Add:
    - --no-cuda-version-check
    - -D__clangd__  # 添加你的自定义选项
  Remove:
    - -forward-unknown-to-host-compiler
    - --expt-*
    - -gencode*
    - --generate-code*
    - -Xfatbin*
    - -arch=*
    - -rdc=*
```

## 内含插件列表

完整插件列表，请查看 [`lua/archvim/plugins.lua`](lua/archvim/plugins.lua)，你可以编辑该文件，从而修改配置或添加新的插件。

### 语法高亮支持

```
c,cpp,cuda,cmake,lua,python,html,javascript,css,json,bash,regex,markdown,glsl,vim,vimdoc
```

你可以输入 `:TSInstall <language>` 来安装更多语言的语义高亮支持。

### 用于代码补全的 LSP 服务器

```
clangd,pyright,lua_ls
```

可以通过执行 `:Mason` 或修改 [`lua/archvim/config/lspconfig.lua`](lua/archvim/config/lspconfig.lua) 来安装更多语言的 LSP 补全支持。

### 脚本会创建或修改的文件

```
/usr/bin/nvim
/usr/bin/.nvim.appimage.noextract
~/.config/nvim
~/.local/share/nvim
~/.config/clangd
~/.clang-format
```

* 如果脚本发现您已经存在 `~/.config/nvim` 目录，则会将其备份至 `~/.config/.nvim.backup.随机数字`。
* 如果脚本发现您已经存在 `/usr/bin/nvim` 可执行文件，但版本不足 v0.10.0，则会用本整合包内置的 nvim.AppImage 替换他。
* 请勿以 sudo 模式运行本脚本，本脚本内部自动会在需要时采取 sudo。

> 欲了解本整合包安装与打包原理，请看 [`.compile.sh`](.compile.sh)。

## 手动安装（不推荐）

如果你有稳定的 GitHub 外网连接，并且已经自己安装好了 NeoVim 版本 v0.10.0 以上，也可以尝试运行以下命令手动安装：

```bash
test -f ~/.config/nvim && mv ~/.config/nvim{,.backup}
git clone https://github.com/archibate/vimrc ~/.config/nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
bash ~/.config/nvim/install_deps.sh
```

> 手动安装的好处是你以后只需 `git pull` 就可以更新上小彭老师最新改动，缺点是他不会自动为你安装依赖项，也不会帮你升级 NeoVim 版本，不建议使用。

初次进入会有一些报错，若提示你包缺失，输入 `:PackerInstall` 即可自动安装全部所需的包（需要连接 GitHub），重启后稍等片刻，即可开始使用 nvim。

## 其他软件的配置文件参考

[`dotfiles/`](dotfiles/) 文件夹下有其他小彭老师自用的配置文件，欢迎参考。

```bash
$ ls -A dotfiles
.bashrc  .clang-format  .gdbinit  .inputrc  .zshrc  .config/
```

其中 `.clang-format` 是我推荐的 C/C++ 代码格式化方案，如果你是一键安装脚本那已经自动帮你拷贝到 `~` 了。

安装以后，当你在一个 C++ 源码中运行 `:Neoformat` 命令时，会采用其中的方案。但如果当前项目根目录下有 `.clang-format` 文件，则优先采用当前项目的。

## 旧版本 Vimrc

本分支为最新 NeoVim 版插件整合包，对于来自 BV1H44y1V7DW 视频想领取老版 Vim 插件的同学，请移步 [main 分支](https://github.com/archibate/vimrc/tree/main)。

另外，NeoVim（`~/.config/nvim`）和 Vim（`~/.vim`）的配置完全独立，互不干扰，所以你可以同时拥有两个配置，取决于你启动的是 `nvim` 还是 `vim`。

## 配色方案

```vim
:colorscheme zephyr  " 默认
:colorscheme gruvbox
```

## 以下为写给小彭老师自己看的

通过运行 `./.compile.sh` 生成 `.build_cache/nvimrc-install.sh` 这个一键安装脚本（约 25 MiB）后，我会把他发布到 142857.red。

我会运行 `docker run -v $PWD/.build_cache:/mnt -it --rm ubuntu:20.04` 来测试兼容性。

在 Ubuntu 容器中，我会用 `NODEP=1 bash nvimrc-install.sh` 避免使用包管理器，加速安装，方便测试。

TODO: 适配 nvim v0.10.0？
