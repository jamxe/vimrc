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

## 开始上手

### 常用键位映射

#### 基本功能

请注意，原先 Vim 自带的用于记录宏的 `q` 键位，被我重新映射为退出键。

使用 `q` 保存并退出当前窗口，方便且直观。

很多插件都在自己的子窗口中这样映射 `q` 为关闭窗口，所以我索性把 `q` 作为所有窗口统一的关闭方式了。

对于已经习惯使用 `q` 来记录宏的用户可能难以接受，如需记录宏，请改用大写的 `Q`（Shift+Q）。

- `q` / `:Quit` 保存并退出当前窗口
- `ZQ` / `:q!` 不保存就强制退出当前窗口
- `Q` 记录宏，再按一次停止记录
- `@` 播放宏

`$` 和 `^` 需要按住 Shift 很不爽，因此我提供了更轻松的 `gl` 和 `gh` 作为代替。

- `gl` / `$` 移动到行末尾
- `gh` / `^` 移动到行开头（不包括空格）
- `3gl` / `$2l` 移动到行末尾倒数第 3 个字符
- `3gh` / `^2h` 移动到行开头倒数第 3 个字符
- `gm` 移动到当前行中央位置

您可以自行修改 [`~/.config/nvim/lua/archvim/mappings.lua`](lua/archvim/mappings.lua) 来改变键位，例如：

```lua
-- 讨厌 q 用作退出的“宏孝子”请删除这 3 行：
vim.keymap.set("n", "q", "<cmd>Quit<CR>", { silent = true })
vim.keymap.set("v", "q", "<Esc>", { silent = true })
vim.keymap.set("n", "Q", "q", { silent = true, noremap = true })
```

> 别误会，小彭老师也是“Vim 宏”的忠实大粉丝啊！只不过关窗口更习惯 `q` 了，用的比宏录制多。

#### 各类功能窗口

以下均为开关额外功能窗口类的键位，按一下就会打开，再按一下可以关闭。

- `<F12>` / `:AerialToggle` 打开大纲
- `<F10>` / `:Neogit` 打开 Git 面板
- `<F9>` / `:TroubleToggle` 打开语法错误列表
- `<F8>` / `:ToggleTerm` 打开内置终端
- `<F7>` / `:NvimTreeToggle` 打开文件树
- `<F6>` / `:copen` 打开编译错误列表
- `<F5>` / `:TermExec cmd=./run.sh` 运行 `./run.sh`，这里面可以放你项目的构建和运行指令
- `<S-F5>` / `:TermExec cmd=\<C-c>` 中断当前在终端中执行的程序（发送 Ctrl+C 的效果）

注意当 `<F5>` 检测到当前项目是一个 CMake 项目，会优先使用 `:CMakeRun`，见下文。

#### CMake 项目支持

以下命令为 `cmake-tools` 的功能，仅当项目根目录检测到 `CMakeLists.txt` 时可用。

- `:CMakeGenerate` 配置当前项目，等价于 `cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
- `:CMakeBuild` 构建当前项目，等价于 `cmake --build build`

- `<F5>` / `:CMakeRun` 运行当前项目，等价于 `build/<your app>`，第一次运行时会询问要选择哪个可执行目标
- `<S-F5>` / `:CMakeStopRunner` 终止运行，杀死当前终端中的正在运行的程序

- `:CMakeSelectBuildDir` 选择构建目录，默认为当前目录下的 `build` 子目录
- `:CMakeSelectBuildType` 选择构建类型：`Release`、`RelWithDebInfo`、`MinSizeRel`、`Debug`
- `:CMakeSelectLaunchTarget` 选择以后要运行的目标

#### 标签页管理 (bufferline.nvim)

- `<F4>` / `:wa` 一键保存所有打开的文件

- `<F3>` / `gt` / `:BufferLineCycleNext` 切换到下一个标签页
- `<F2>` / `gb` / `:BufferLineCyclePrev` 切换到上一个标签页
- `<F1>` / `g<Tab>` / `:BufferLineTogglePin` 将当前标签页固定在最前

- `<S-F3>` / `gT` / `:BufferLineMoveNext` 将当前标签页右移一位
- `<S-F2>` / `gB` / `:BufferLineMovePrev` 将当前标签页左移一位
- `<S-F1>` / `g<BS>` / `:bd` 关闭当前标签页

- `<C-S-F3>` / `g<C-t>` / `:BufferLineCloseRight` 关闭右侧所有标签页
- `<C-S-F2>` / `g<C-b>` / `:BufferLineCloseLeft` 关闭左侧所有标签页
- `<C-S-F1>` / `g<S-Tab>` / `:BufferLineCloseOthers` 关闭除当前标签页外所有

- `g<Space>` / `:BufferLinePick` 选择跳转到一个标签页

#### 语言支持 (LSP)

此类和语言有关的快捷键均为 `g` 开头，在普通模式（NORMAL）中使用。

虽然 LSP 是 NeoVim 原生支持的，无需任何插件；但 LSP 只是个协议，还是需要安装相应的 LSP 服务器如 `clangd` 或 `pyright` 才能识别对应的语言。

我的一键安装脚本应该已经为你自动安装了 `clangd` 和 `pyright`，可以运行 `clangd --version` 来检查，如果没有 `clangd` 则无法在 C++ 文件中实现以下这些功能。

- `gd` 跳转到当前光标下函数、变量、或类的定义。如果在一个 `#include <cstdio>` 语句上，则会打开并跳转到 `cstdio` 这个标准库头文件的正确位置。
- `gy` 跳转到当前光标下变量的定义，与
- `gr` 跳转到当前光标下函数、变量、或类的所有引用，也就是查找谁使用了当前这个函数或变量。会弹出一个列表，让你用 `j/k` 移动选择，按 `<CR>` 即可跳转到选中的那个引用所在的文件。
- `gD` 跳转到当前光标下函数的所有实现，也就是查找当前虚函数的所有 override。如果有多个实现，则会弹出一个列表，让你用 `j/k` 移动选择，按 `<CR>` 即可跳转到选中的那个实现。

小贴士：使用 `gd` 跳转过去后，如果想要回来，只需要按 `<C-o>`（Ctrl+O）就能恢复到原来编辑的文件和位置，非常方便。

如果连续跳转了多次，也可以通过多次按 `<C-o>` 逐级退回原来的位置。

- `<C-o>` / `<S-Tab>`（普通模式下）回退到上一次跳转的位置。
- `<C-i>` / `<Tab>`（普通模式下）取消回退，前进到下一次跳转的位置。

您可以自行修改 [`~/.config/nvim/lua/archvim/config/lspconfig.lua`](lua/archvim/config/lspconfig.lua) 来添加不同语言的支持及其配置。

- `gf` 打开光标下的文件，创建一个新新标签页并跳转过去，如果检测到形如 `file.cpp:12`，则还会跳转到相应的行号
- `gx` 打开光标下的超链接，如果不是超链接而是普通文件名，则会用系统默认应用程序打开文件

- `gn` 重命名当前光标下的函数、变量、或类，在文本框中输入新的名称即可。
- `gN` / `:IncRename` 类似，但不会自动带上初始名称。

- `go` / `:Ouroboros` 快速在头文件和源文件之间来回跳转，非常实用，C/C++ 开发者必备功能
- `gO` / `:split | Ouroboros` 打开对应的头文件或源文件，上下分割呈两个窗口，同时显示
- `g<C-o>` / `:vsplit | Ouroboros` 打开对应的头文件或源文件，左右分割呈两个窗口，同时显示

如果对应的 `.cpp` 或 `.h` 文件不存在，Ouroboros 还会提示你自动创建。

- `gw` 应用 Code Actions 尝试修复当前行存在的问题

例如在一个“标识符未定义”的静态分析报错上方，运行 `gw`，可以自动导入缺少的头文件。

- `g=` / `:Neoformat` 格式化当前文件或选中的区间

注意 `:Neoformat` 实际上是调用了 `clang-format` 或 `pylint` 等语言特定工具，我的一键脚本已经替你安装了 `clang-format`。

默认的 `clang-format` 风格非常糟糕，居然是 Tab 缩进为 2 的。好在我的一键安装脚本已经为你准备了一个全局的 [`~/.clang-format`](dotfiles/.clang-format)，Tab 缩进为 4，适合大多数人 C++ 风格需求。若不满意可以自行修改，或采用项目目录下的局域 `.clang-format` 来覆盖。

如果有自定义的代码规范需求，可以在当前项目目录下创建一个 [`.clang-format` 配置文件](https://clang.llvm.org/docs/ClangFormatStyleOptions.html) 来调整，满足撕人老板的要求。

- `ga` / `:ascii` 查看当前光标下字符的 Unicode 二进制编码信息
- `:PyrightOrganizeImports` 为当前 Python 代码中的所有 `import` 排序

#### 语法树分析 (nvim-treesitter)

以下两个键位可用于虚拟模式（VISUAL）中，快速扩大当前选中区间到下一个更大的语法块，或缩小回退到更小的一块。

- `+` 扩大选择块
- `-` 缩小选择块

其中 `+` 在普通模式（NORMAL）也可用，会选中当前光标下的最子语句块。

例如：

```cpp
int main() {
    return 42;
}
```

光标在 `42` 上方按 `+`，会选中 `42`。

继续按 `+`，会选中 `return 42`，继续按，直至选中整个 `main` 函数。

适用场景：如果你不喜欢 `viw` 或 `vif` 之类一次性完成的选择，可以多次按 `+` 和 `-` 调整，渐进地选出想要的范围。

#### 全局搜索功能 (telescope.nvim)

用于搜索并跳转到想要的位置，此类快捷键均以 `,` 开头。

弹出搜索窗口后，按 `<Up>` `<Down>` 可以定位，`<CR>` 跳转，鼠标双击亦可。

搜索窗口的输入文本框初始为插入模式，此时直接按键即可输入你要查询的文本。

插入模式中按一下 `<Esc>` 会退回到普通模式，普通模式中按 `j` `k` 来定位查询结果，按 `ciw` 修改一个单词，按 `i` 回到输入模式。

连按两下 `<Esc>`，即可关闭搜索窗口。

注意：对于文件搜索，`.gitignore` 和 `.rgignore` 中指定的文件将被排除。这是为了避免不小心定位到无聊的二进制文件，例如 `build` 目录中的垃圾文件。

**文件搜索**

- `,l` 按文件名搜索当前项目中的所有文件——朴实无华的全局定位功能，按名字搜索所有项目中的文件，伟大无需多言
- `,b` 列出当前 NeoVim 已打开的文件，即所有标签页——当你打开了特别多标签页找不到头时，就需要用到这个
- `,o` 所有最近打开过的历史文件——最近用过的文件会排在最前，用 `j/k` 就能快速跳转过去，因为你下一个想要打开的大概率是历史记录里有的文件，非常方便，小彭老师平时启动 NeoVim 的第一件事就是 `,o`，打开上次编辑的文件，唯一的缺点是有时会留存了非当前项目的历史记录干扰

- `,L` 按文件名搜索当前项目中的所有 `.c/.cpp` 源文件和 `.h/.hpp` 头文件，智能根据你的 CMake 配置
- `,O` 按文件名搜索当前项目中的所有 `CMakeLists.txt` 和 `.cmake` 文件，智能根据你的 CMake 配置
- `,i` 按文件名搜索当前项目中的所有已被纳入 Git 仓库的文件，`.gitignore` 中的文件将被排除，相当于 `git add` 的历史
- `,p` 按文件名搜索当前项目中的所有 Git 仓库中未提交的修改文件，相当于 `git status` 的输出——因为经常需要在最近修改过的几个文件之间快速跳转，而常用文件往往就是当前 commit 中修改了的文件，比较实用

**字符串搜索**

- `,k` 按正则表达式全局搜索所有文件中的字符串——用于跨文件跳转，很常用，可以在不方便用 `gd` 和 `gr` 时提供兜底的按文本搜索
- `,,` 模糊搜索当前打开文件中的字符串——用于单个文件内的跳转，虽然 Vim 自带的 `/` 搜索也能提供相似的单文件搜索功能，但 `,,` 的好处是以列表的形式展现，方便统一查看很多个匹配结果，而且模糊匹配不要求严格符合
- `,z` 当前文件中的所有文本对象，需要 `:TSInstall cpp` 安装当前语言的语法解析树支持，一键安装脚本已替你安装
- `,x` 当前文件中的所有符号，需要 `:MasonInstall clangd` 安装当前语言的 LSP 支持，一键安装脚本已替你安装

**跳转位置搜索**

- `,m` 查看当前 Vim 的所有标记——可以用 `mx` 来创建一个名为 “x” 的标记，用 `'x` 来跳转到他，而 `,m` 可以快速列出所有你设置过的标记，按 `<CR>` 即可跳转到选中的标记
- `,j` 查看当前 Vim 的跳转历史，这里记录着你所有曾经跳转过的地方，按 `<CR>` 就能再次跳转过去

**其他特色功能**

- `,c` 查看当前 Git 仓库的全部提交历史，相当于 `git log` 输出的列表，可以按 commit 的编号或标题搜索
- `,v` 查看当前 Git 仓库的所有分支，相当于 `git branch` 输出的列表，按 `<CR>` 即可切换到选中的分支
- `,:` 模糊查询 NeoVim 中用 `:` 输入过的命令历史，按 `<CR>` 可以再次执行该命令
- `,/` 模糊查询 NeoVim 中用 `/` 搜索过的文本历史，按 `<CR>` 可以再次搜索该字符串
- `,;` 模糊查询所有 NeoVim 命令，帮助你学习 NeoVim
- `,?` 模糊查询 NeoVim 官方及其插件的所有帮助文档，帮助你学习 NeoVim

以上设置均可以在 [`~/.config/nvim/lua/archvim/telescope.lua`](lua/archvim/telescope.lua) 中修改。

#### 编译错误列表 (QuickFix)

QuickFix 是 Vim 和 NeoVim 内置的功能，用于捕获编译器产生的错误文件名和行号信息，`<CR>` 或者双击可以快速跳转到错误的位置，方便你修改。

每次运行过 `<F5>` 或 `:CMakeBuild` 后，如果产生了编译错误，就会弹出 QuickFix 窗口。

可以通过以下两个快捷键定位到编译错误所在的位置：

- `<F6>` / `:cnext` 跳转到下一个编译错误所对应的文件和行号
- `<S-F6>` / `:cprev` 跳转到上一个编译错误所对应的文件和行号

当 QuickFix 窗口还没有打开时，可以按 `<F6>` 唤出，之后再按 `<F6>` 则为跳转到下一个编译错误。

通常光标总是位于 QuickFix 外，发生错误的文件中，此时 `<F6>` 和 `<S-F6>` 可以在多个错误位置之间来回跳转。

光标在 QuickFix 窗口中时，按 `<Esc>` 或再按 `<F6>` 可以关闭 QuickFix。

#### 文件树 (nvim-tree)

- `<F7>` 打开文件树

打开文件树时，会自动尝试定位到到当前正在编辑的文件，非常方便。

- `j` 移动到下一个文件
- `k` 移动到上一个文件
- `<` 移动到当前同目录下的下一个文件
- `>` 移动到当前同目录下的上一个文件
- `]c` 移动到下一个 Git 有修改的文件，根据 `git status`
- `[c` 移动到上一个 Git 有修改的文件，根据 `git status`
- `]d` 移动到下一个有静态检查报错的文件，根据 `clangd`
- `[d` 移动到上一个有静态检查报错的文件，根据 `clangd`

- `o` / `<CR>` 打开光标下的文件，或展开文件夹，再按一次可以重新折叠起文件夹
- `<C-v>` 打开光标下的文件，但会左右分割成两个窗口，左侧是新打开的文件
- `<C-x>` 打开光标下的文件，但会上下分割成两个窗口，上方是新打开的文件
- `<C-e>` 就地打开光标下的文件，会直接顶替掉文件树窗口
- `<Tab>` 打开光标下的文件，但光标依然保留在文件树中不动
- `<C-k>` 查看文件大小、修改日期、属性等信息

这里面最常用的就是 `<CR>`，鼠标双击也可以打开文件或展开文件夹。

- `a` 创建一个新文件，会弹出窗口询问新文件名，输入的文件名以 `/` 结尾则可以创建文件夹，否则创建普通文件
- `d` 删除光标下的文件（需要按 y 确认，按任意键取消）
- `D` 将光标下的文件移动到垃圾桶

- `c` 复制当前光标下的文件，放到剪切板（类似于 Ctrl-C）
- `x` 剪切当前光标下的文件，放到剪切板（类似于 Ctrl-X）
- `p` 将剪切板中的文件粘贴（类似于 Ctrl-V）

> 如果之前是 `x` 剪切的，那么 `p` 粘贴后原来文件会消失，只保留新文件；如果之前是 `c` 拷贝的，那么 `p` 粘贴后，原来的文件依然在那里，新老文件同时存在。

运用 `x` 和 `p`，可以在不同的文件夹之间移动文件。

- `r` 重命名当前文件或文件夹，会弹出一个编辑框让你编辑新文件名
- `<C-r>` 重命名当前文件或文件夹，会弹出一个编辑框让你编辑新文件名，但原来的文件名不自动填入，允许你自己从零开始写出整个文件名
- `e` 重命名当前文件，但不改变后缀名，例如 `hello.lua` 则只会修改 `hello` 的部分
- `u` 重命名当前文件或文件夹，包括完整的绝对路径，从而可以在不同文件夹之间移动

- `y` 拷贝当前文件名
- `Y`（Shift+Y）拷贝当前文件相对于项目根目录的相对路径
- `gy` 拷贝当前文件的绝对路径
- `ge` 拷贝当前文件名，但不包括扩展名

常用于拷贝文件路径后粘贴到终端访问。

- `.` 对光标下的文件执行任意 Vim 命令
- `s` 用系统默认应用程序打开光标下的文件（类似于 `gx` 快捷键）

- `<BS>` 关闭展开的文件夹
- `E` 递归展开当前光标下的文件夹，及其中的所有子文件夹
- `W` 递归折叠当前光标下的文件夹

- `<C-]>` 将光标下的文件夹设为工作目录（类似于 `cd` 命令）
- `-` 工作目录回退到上一层目录（类似于 `cd ..` 的效果）

- `m` 添加书签标记
- `bmv` 移动书签标记的文件到此处
- `bd` 删除书签标记的文件
- `bt` 移动书签标记的文件到垃圾桶
- `g?` 查看快捷键帮助

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
