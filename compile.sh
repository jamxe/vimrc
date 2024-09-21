set -e
cd "$(dirname "$0")"
if [ "x$ARCHIBATE_COMPUTER" = "x" ]; then
    echo "-- WARNING: This script is used for compiling bundle, not for end-users!"
    echo "-- WARNING: End users should use this command to install:"
    echo "-- 警告: 此脚本仅用于编译插件包，而非末端用户！"
    echo "-- 警告: 末端用户请使用此命令安装："
    echo "curl -SLf https://142857.red/files/nvimrc-install.sh | bash"
    exit 1
fi
unset ARCHIBATE_COMPUTER
export ARCHIBATE_COMPUTER
compress=z
version_min=090
treesitters=(c cpp cuda cmake lua python html javascript css json bash regex markdown diff glsl vim vimdoc)
commands=(sudo base64 tar mktemp cat tee rm mkdir test cp mv stat grep echo uname)

cache="$PWD/.build_cache"
payload="$cache"/archvim-release.tar.gz
script="$cache"/nvimrc-install.sh

mkdir -p "$cache"
nvim --headless --cmd "let g:archvim_predownload=2 | let g:archvim_predownload_cachedir='$cache/archvim-build'" -c 'q'
git --version > /dev/null
rm -rf "$cache"/archvim-release
mkdir -p "$cache"/archvim-release
cp -r ./lua ./init.vim ./scripts ./dotfiles "$cache"/archvim-release
sed -i "s/\"let g:archvim_predownload=1/let g:archvim_predownload=1/" "$cache"/archvim-release/init.vim
rm -rf "$cache"/archvim-release/lua/archvim/predownload
cp -r "$cache"/archvim-build/predownload "$cache"/archvim-release/lua/archvim
rm -rf "$payload"
cd "$cache"/archvim-release
mkdir -p "$cache"/archvim-release/nvim-treesitter-parser
for x in ${treesitters[@]}; do
    cp ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser/"$x".so "$cache"/archvim-release/nvim-treesitter-parser
done
for x in "$cache"/archvim-release/nvim-treesitter-parser/*.so; do
    strip -s "$x"
done
cp -r ~/.local/share/nvim/mason/registries/github/mason-org/mason-registry "$cache"/archvim-release
test -f "$cache"/archvim-nvim.appimage || curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o "$cache"/archvim-nvim.appimage
cp "$cache"/archvim-nvim.appimage "$cache"/archvim-release/nvim.appimage
chmod u+x nvim.appimage
tar -${compress}cf "$payload" .
cd "$(dirname "$0")"
rm -rf "$cache"/archvim-release

# https://stackoverflow.com/questions/29418050/package-tar-gz-into-a-shell-script
printf "#!/bin/bash
set -e
echo '-- Welcome to the ArchVim installation script'
echo '-- 欢迎使用小彭老师 ArchVim 一键安装脚本'
which ${commands[*]} > /dev/null || (echo \"ERROR: One of the following command(s) not found: ${commands[*]}\" && exit 1)
tmpdir=\"\$(mktemp -d)\"
tmpzip=\"\$(mktemp)\"
rm -rf \$tmpdir
mkdir -p \$tmpdir
echo '-- Fetching bundled data...'
echo '-- 正在下载插件包，请稍等...'
cat > \$tmpzip << __ARCHVIM_PAYLOAD_EOF__\n" > "$script"

base64 "$payload" >> "$script"

printf "\n__ARCHVIM_PAYLOAD_EOF__
cd \$tmpdir
echo '-- Extracting bundled data...'
base64 -d < \$tmpzip | tar -${compress}x
test -f ./scripts/install_deps.sh || echo \"ERROR: cannot extract file, make sure you have base64 and tar working\"
echo '-- Checking NeoVim version...'
if which nvim; then
    stat \"\$(which nvim)\" || true
    sudo chmod +x \"\$(which nvim)\" || true
    version=\"1\$(nvim --version | head -n1 | cut -f2 -dv | sed s/\\\\.//g)\"
else
    version=0
fi
(which nvim >/dev/null 2>/dev/null && [ \"\$version\" -ge 1$version_min ]) || bash ./scripts/install_nvim.sh || echo -e \"\\n\\nERROR: cannot install NeoVim >= 0.9.1! Consider install it manually...\\n错误：无法自动安装 NeoVim 0.9.1 以上的版本！您可能需要手动安装一下……\\n\\n\"
nvim --version
if [ -d ~/.config/nvim ]; then
    echo \"-- Backup existing config to ~/.config/.nvim.backup.\$\$...\"
    mv ~/.config/nvim ~/.config/.nvim.backup.\$\$
fi
echo '-- Copying to ~/.config/nvim...'
mkdir -p ~/.config
rm -rf ~/.config/nvim
cp -r . ~/.config/nvim
if [ \"x\$NODEP\" = \"x\" ]; then
    echo '-- Installing dependencies...'
    bash ~/.config/nvim/scripts/install_deps.sh || echo -e \"\\n\\n--\\n--\\n-- WARNING: some dependency installation failed, please check your internet connection.\n-- If you see this message, please report the full terminal output to archibate by opening GitHub issues.\\n-- ArchVim can still run without those dependencies, though.\\n-- You can always try re-run dependency installation by running: bash ~/.config/nvim/scripts/install_deps.sh\\n\\n--\\n--\\n-- 警告: 某些依赖项安装失败，请检查包管理器是否配置为国内源并有网络连接。\\n-- ArchVim 仍然可以正常运行，但是可能会缺少某些功能。\\n-- 如果你看到本消息，请通过 GitHub 向小彭老师反馈并贴上终端的完整输出。\\n-- 修复网络问题后，你也可以手动再次尝试安装依赖项：bash ~/.config/nvim/scripts/install_deps.sh\\n--\\n--\\n\\n\"
fi
echo '-- Synchronizing packer.nvim...'
# rm -rf ~/.local/share/nvim/site/pack/packer
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerClean'
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerCompile'
echo '-- Copying language supports...'
mkdir -p ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser
mv ~/.config/nvim/nvim-treesitter-parser/*.so ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser/
if [ \"x\$(uname -sm)\" != \"xLinux x86_64\" ]; then
    echo 'WARNING: Not x86_64 linux, may need manually run :TSInstall cpp later!'
fi
rm -rf ~/.config/nvim/nvim-treesitter-parser
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
echo '-- Verifying treesitters...'
(nvim --headless -c \"TSInstallInfo\" -c 'sleep 1 | q!' 2>&1 | grep -v 'not installed') || echo 'no installed treesitters?'
if [ \"x\$(uname -sm)\" != \"xLinux x86_64\" ]; then
    for x in ${treesitters[*]}; do
        nvim --headless -c \"TSUpdateSync \$x\" -c 'sleep 1 | q!'
    done
    nvim --headless -c \"TSInstallInfo\" -c 'sleep 1 | q!'
fi
echo '-- Finishing installation...'
rm -rf \$tmpdir \$tmpzip
cd ~/.config/nvim
bash ~/.config/nvim/scripts/customize_settings.sh || true

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
echo \"-- If you manually added any plugins, run :PackerSync and :PackerCompile to apply.\"
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
echo \"-- 如果手动添加了新插件，记得 :PackerSync 和 :PackerCompile 才能生效。\"
echo \"-- 如需卸载本插件包，只需删除 ~/.config/nvim 文件夹。\"
if [ -f ~/.config/.nvim.backup.\$\$ ]; then
    echo \"-- 想恢复旧配置？把本脚本自动备份的 ~/.config/.nvim.backup.\$\$ 移动回 ~/.config/nvim 即可。\"
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
