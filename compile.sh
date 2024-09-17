set -e
cd "$(dirname "$0")"
if [ "x$ARCHIBATE_COMPUTER" == "x" ]; then
    echo "-- WARNING: This script is used for compiling bundle, not for end-users!"
    echo "-- WARNING: End users should use this command to install:"
    echo "-- 警告: 此脚本仅用于编译插件包，而非末端用户！"
    echo "-- 警告: 末端用户请使用此命令安装："
    echo "curl -sSLf https://142857.red/files/nvimrc-install.sh | bash"
    exit 1
fi
unset ARCHIBATE_COMPUTER
export ARCHIBATE_COMPUTER
cache="$PWD/.build_cache"
version_min=090
mkdir -p "$cache"
nvim --headless --cmd "let g:archvim_predownload=2 | let g:archvim_predownload_cachedir='$cache/archvim-build'" -c 'q'
git --version > /dev/null
rm -rf "$cache"/archvim-release
mkdir -p "$cache"/archvim-release
cp -r ./lua ./init.vim ./install_deps.sh ./dotfiles "$cache"/archvim-release
sed -i "s/\"let g:archvim_predownload=1/let g:archvim_predownload=1/" "$cache"/archvim-release/init.vim
rm -rf "$cache"/archvim-release/lua/archvim/predownload
cp -r "$cache"/archvim-build/predownload "$cache"/archvim-release/lua/archvim
rm -rf "$cache"/archvim-release.tar.gz
cd "$cache"/archvim-release
mkdir -p "$cache"/archvim-release/nvim-treesitter-parser
for x in ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser/{c,cpp,cuda,cmake,lua,python,html,javascript,css,json,bash,regex,markdown,diff,glsl,vim,vimdoc}.so; do
    cp "$x" "$cache"/archvim-release/nvim-treesitter-parser
done
for x in "$cache"/archvim-release/nvim-treesitter-parser/*.so; do
    strip -s "$x"
done
cp -r ~/.local/share/nvim/mason/registries/github/mason-org/mason-registry "$cache"/archvim-release
test -f "$cache"/archvim-nvim.appimage || curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o "$cache"/archvim-nvim.appimage
cp "$cache"/archvim-nvim.appimage nvim.appimage
chmod u+x nvim.appimage
tar -zcf "$cache"/archvim-release.tar.gz .
cd "$(dirname "$0")"
rm -rf "$cache"/archvim-release

payload="$cache"/archvim-release.tar.gz
script="$cache"/nvimrc-install.sh
# https://stackoverflow.com/questions/29418050/package-tar-gz-into-a-shell-script
printf "#!/bin/bash
# which tee > /dev/null 2> /dev/null && TEE=(tee /tmp/archvim.log) || TEE=cat
# (bash | \${TEE[@]}) << __ARCHVIM_SCRIPT_EOF__
set -e
echo '-- Welcome to the ArchVim installation script'
echo '-- 欢迎使用小彭老师 ArchVim 一键安装脚本'
which sudo > /dev/null 2> /dev/null && SUDO=sudo || SUDO=
which base64 > /dev/null
which tar > /dev/null
which mktemp > /dev/null
which cat > /dev/null
which tee > /dev/null
which rm > /dev/null
which mkdir > /dev/null
which test > /dev/null
which cp > /dev/null
which mv > /dev/null
which stat > /dev/null
tmpdir=\"\$(mktemp -d)\"
tmptgz=\"\$(mktemp)\"
rm -rf \$tmpdir
mkdir -p \$tmpdir
echo '-- Fetching bundled data...'
echo '-- 正在下载插件包，请稍等...'
cat > \$tmptgz << __ARCHVIM_PAYLOAD_EOF__\n" > "$script"

base64 "$payload" >> "$script"

printf "\n__ARCHVIM_PAYLOAD_EOF__
cd \$tmpdir
echo '-- Extracting bundled data...'
base64 -d < \$tmptgz | tar -zx
test -f ./install_deps.sh || echo \"ERROR: cannot extract file, make sure you have base64 and tar working\"
fix_nvim_appimage() {
    \$SUDO mv /usr/bin/nvim /usr/bin/.nvim.appimage.noextract
    echo 'x=\$\$; mkdir -p /tmp/_nvim_appimg_.\$x && bash -c \"cd /tmp/_nvim_appimg_.\$x && /usr/bin/.nvim.appimage.noextract --appimage-extract > /dev/null 2>&1\" && /tmp/_nvim_appimg_.\$x/squashfs-root/AppRun \"\$@\"; x=\$?; rm -rf /tmp/_nvim_appimg_.\$x exit \$x' | \$SUDO tee /usr/bin/nvim
    \$SUDO chmod +x /usr/bin/nvim
}
install_nvim() {
    echo \"-- NeoVim 0.9.1 or above not found, installing latest for you\"
    test -f ./nvim.appimage || curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.config/nvim/nvim.appimage
    \$SUDO chmod +x ./nvim.appimage
    test -f /usr/bin/nvim && \$SUDO mv /usr/bin/nvim /tmp/.nvim-executable-backup
    \$SUDO cp ./nvim.appimage /usr/bin/nvim
    nvim --version || fix_nvim_appimage
}
echo '-- Checking NeoVim version...'
if which nvim; then
    stat \"\$(which nvim)\" || true
    \$SUDO chmod +x \"\$(which nvim)\" || true
    version=\"1\$(nvim --version | head -n1 | cut -f2 -dv | sed s/\\\\.//g)\"
else
    version=0
fi
(which nvim >/dev/null 2>/dev/null && [ \"\$version\" -ge 1$version_min ] ${version_max-" && [ \"\$version\" -le 1$version_max ]"}) || install_nvim
nvim --version
if [ -d ~/.config/nvim ]; then
    echo \"-- Backup existing config to ~/.config/.nvim.backup.\$\$...\"
    mv ~/.config/nvim ~/.config/.nvim.backup.\$\$
fi
echo '-- Copying to ~/.config/nvim...'
mkdir -p ~/.config
rm -rf ~/.config/nvim
cp -r . ~/.config/nvim
if [ \"x\$NODEP\" == \"x\" ]; then
    echo '-- Installing dependencies...'
    \$SUDO bash ~/.config/nvim/install_deps.sh || echo -e \"\\n\\n--\\n--\\n-- WARNING: some dependency installation failed, please check your internet connection.\n-- If you see this message, please report the full terminal output to archibate by opening GitHub issues.\\n-- ArchVim can still run without those dependencies, though.\\n-- You can always try run dependency installation again by running: sudo bash ~/.config/nvim/install_deps.sh\\n\\n--\\n--\\n-- 警告: 某些依赖项安装失败，请检查网络连接。\\n-- ArchVim 仍然可以正常运行，但是可能会缺少某些功能。\\n-- 如果你看到本消息，请通过 GitHub 向小彭老师反馈并贴上终端的完整输出。\\n-- 你也可以手动尝试运行依赖项安装命令：sudo bash ~/.config/nvim/install_deps.sh\\n--\\n--\\n\\n\"
fi
echo '-- Synchronizing packer.nvim...'
# rm -rf ~/.local/share/nvim/site/pack/packer
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerClean'
echo '-- Copying language supports...'
mkdir -p ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser
mv ~/.config/nvim/nvim-treesitter-parser/*.so ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser/
rmdir ~/.config/nvim/nvim-treesitter-parser
echo '-- Copying mason registries...'
mkdir -p ~/.local/share/nvim/mason/github/mason-org/mason-registry
mv ~/.config/nvim/mason-registry/* ~/.local/share/nvim/mason/github/mason-org/mason-registry/
rmdir ~/.config/nvim/mason-registry
echo '-- Copying clangd configurations...'
if [ ! -f ~/.config/clangd/config.yaml ]; then
    mkdir -p ~/.config/clangd/
    ln -sf ~/.config/nvim/dotfiles/.config/clangd/config.yaml ~/.config/clangd/config.yaml
fi
if [ ! -f ~/.clang-format ]; then
    ln -sf ~/.config/nvim/dotfiles/.clang-format ~/.clang-format
fi
echo '-- Finishing installation...'
rm -rf \$tmpdir \$tmptgz
echo
mkdir -p ~/.local/share/nvim/archvim
echo \"-- Configuring ~/.local/share/nvim/archvim/opts.json\"

echo
echo \"=================================\"
echo \"现在开始为您的个性化定制，如果不确定，可以一路按 ENTER 下去\"

key=nerd_fonts
val=true
quest_en='Did your terminal shows this symbols correctly?  (clock symbol)'
quest_zh='您的终端是否能正常显示此字符？ （应为时钟符号）'
echo
echo \"=================================\"
echo
echo \"==> \$quest_en\"
echo \"==> \$quest_zh\"
echo -n \"==> 是或否，默认选否 [y/N] \"
read -n1 x 2> /dev/null || read x || x=n
if [ \"x\$x\" != \"xy\" ]; then val=false; else val=true; fi
nvim --headless -c \"lua require'archvim.options'.\$key = \$val\" -c 'sleep 1 | q!'

if ! \$val; then

    quest_en='The symbol \` \` is not showing correctly due to lack of the Nerd Fonts. Would you like to install and enable it right now?'
    quest_zh='此字符 “ ” 无法显示可能是因为您没有安装 Nerd Fonts 字体，要现在安装并启用这款字体吗？'
    echo \"=================================\"
    echo
    echo \"-- Worry not, you may still use NeoVim without the fancy icons.\"
    echo \"-- 别担心，您仍然可以正常使用 NeoVim，只不过没有了一些花哨的图标。\"
    echo
    echo \"==> \$quest_en\"
    echo \"==> \$quest_zh\"
    echo -n \"==> 是或否，默认选否 [y/N] \"
    read -n1 x 2> /dev/null || read x || x=n
    if [ \"x\$x\" == \"xy\" ]; then
        olddir=\"\$PWD\"
        if (curl --connect-timeout 5 -L -o ~/.local/share/fonts/JetBrainsMono.zip https://ghproxy.net/https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/JetBrainsMono.zip || curl --connect-timeout 5 -L -o ~/.local/share/fonts/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/JetBrainsMono.zip) && (cd ~/.local/share/fonts && unzip JetBrainsMono.zip && rm JetBrainsMono.zip) && fc-cache -fv; then
            nvim --headless -c \"lua require'archvim.options'.\$key = true\" -c 'sleep 1 | q!' || true
            echo \"Installed Nerd Fonts for you. Now please goto the terminal settings and select 'JetBrainMono Nerd Fonts' for font, so that it can effect.\"
            echo \"已为您安装 Nerd Fonts，您还需要在终端设置中选择 “JetBrainMono Nerd Fonts“ 字体才能生效。\"
            echo -n \"==> 好的，我会去设置的 [Press any key to continue] \"
            read -n1 x 2> /dev/null || read x || true
        else
            echo \"ERROR: cannot install Nerd Fonts! Worry not, ArchVim installation will continue.\"
            echo \"错误：无法安装 Nerd Fonts，别担心，ArchVim 插件整合包的安装仍能继续。\"
        fi
        cd \$olddir 2> /dev/null || true
    fi

fi

key=disable_notify
val=true
quest_en='Do you need to use this NeoVim in remote connection (SSH)?'
quest_zh='您是否需要在远程连接（SSH）中使用此 NeoVim？'
echo
echo \"=================================\"
echo
echo \"==> \$quest_en\"
echo \"==> \$quest_zh\"
echo -n \"==> 是或否，默认选是 [Y/n] \"
read -n1 x 2> /dev/null || read x || x=y
if [ \"x\$x\" == \"xn\" ]; then val=false; else val=true; fi
nvim --headless -c \"lua require'archvim.options'.\$key = \$val\" -c 'sleep 1 | q!'

key=transparent_color
val=true
quest_en='Did you set any background image for the terminal?'
quest_zh='您是否为终端设定了背景贴图（例如二次元壁纸）？'
echo
echo \"=================================\"
echo
echo \"==> \$quest_en\"
echo \"==> \$quest_zh\"
echo -n \"==> 是或否，默认选是 [Y/n] \"
read -n1 x 2> /dev/null || read x || x=y
if [ \"x\$x\" == \"xn\" ]; then val=false; else val=true; fi
nvim --headless -c \"lua require'archvim.options'.\$key = \$val\" -c 'sleep 1 | q!'

key=enable_inlay_hint
val=true
quest_en='Would you like to enable inlay hints?'
quest_zh='您是否希望开启 Inlay Hint 提示？'
echo
echo \"=================================\"
echo
echo \"Inlay Hint:     add(a: 1, b: 2)\"
echo \"No Inlay Hint:  add(1, 2)\"
echo
echo \"Inlay Hint:     auto i:int = 1;\"
echo \"No Inlay Hint:  auto i = 1;\"
echo
echo \"==> \$quest_en\"
echo \"==> \$quest_zh\"
echo -n \"==> 是或否，默认选是 [Y/n] \"
read -n1 x 2> /dev/null || read x || x=y
if [ \"x\$x\" == \"xn\" ]; then val=false; else val=true; fi
nvim --headless -c \"lua require'archvim.options'.\$key = \$val\" -c 'sleep 1 | q!'

echo
echo \"--\"
echo \"-- You may always edit these settings later in: ~/.local/share/nvim/archvim/opts.json\"
echo \"-- 您以后可以随时修改这些设置：~/.local/share/nvim/archvim/opts.json\"
echo \"--\"

echo
echo \"--\"
echo \"--\"
echo \"-- There might be some errors or warnings generated above, that doesn't effect use!\"
echo \"-- Ignore these messages, as long as you can start nvim, your installation is done.\"
echo \"-- All OK, ArchVim plugins installed into ~/.config/nvim, now run 'nvim' to play.\"
echo \"-- run into any trouble? Feel free to contact me via the GitHub link below.\"
echo \"-- https://github.com/archibate/vimrc/issues\"
echo \"--\"
echo \"-- To update, just download this script again and run.\"
echo \"-- To uninstall, just remove the ~/.config/nvim directory.\"
if [ -f ~/.config/.nvim.backup.\$\$ ]; then
    echo \"-- Need your old nvim config back? We've backup that: ~/.config/nvim.backup.\$\$.\"
fi
echo \"--\"
echo \"-- You may run :checkhealth to check if Neovim is working well.\"
echo \"-- You may run :Mason or :TSInstallInfo to check for installed language supports.\"
echo \"--\"
echo \"--\"
echo \"-- 上面有时可能会有一些报错和警告，请忽略，这对正常使用没有任何影响！\"
echo \"-- 只要你能启动 'nvim' 且无报错弹窗，就说明你的 NeoVim 就已经安装成功。\"
echo \"-- 欢迎向我反馈各种问题和建议：https://github.com/archibate/vimrc/issues\"
echo \"--\"
echo \"-- 如需更新，只需重新下载这个脚本并运行即可，会自动覆盖老的版本。\"
echo \"-- 如需卸载本插件包，只需删除 ~/.config/nvim 文件夹\"
if [ -f ~/.config/.nvim.backup.\$\$ ]; then
    echo \"-- 想恢复旧配置？把本脚本自动备份的 ~/.config/.nvim.backup.\$\$ 移动回 ~/.config/nvim 即可\"
fi
echo \"--\"
echo \"-- 你可以运行 :checkhealth 来检查 NeoVim 是否工作正常。\"
echo \"-- 也可以运行 :Mason 和 :TSInstallInfo 检查本脚本为您安装了哪些语言支持。\"
\n" >> "$script"

rm "$payload"
chmod +x "$script"

echo -- finished with "$script"
if [ "x$1" != "x" ]; then
    echo -- deploying to https://142857.red/nvimrc-install.sh
    scp "$cache"/nvimrc-install.sh root@142857.red:/var/www/html/files/nvimrc-install.sh
fi
