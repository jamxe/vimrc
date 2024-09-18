echo "-- NeoVim 0.9.1 or above not found, installing latest for you."
fix_nvim_appimage() {
    \$SUDO mv /usr/bin/nvim /usr/bin/.nvim.appimage.noextract
    echo 'x=\$\$; mkdir -p /tmp/_nvim_appimg_.\$x && bash -c \"cd /tmp/_nvim_appimg_.\$x && /usr/bin/.nvim.appimage.noextract --appimage-extract > /dev/null 2>&1\" && /tmp/_nvim_appimg_.\$x/squashfs-root/AppRun \"\$@\"; x=\$?; rm -rf /tmp/_nvim_appimg_.\$x exit \$x' | \$SUDO tee /usr/bin/nvim
    \$SUDO chmod +x /usr/bin/nvim
}
if [ "x\$(uname -sm)\" = "xLinux x86_64" ]; then
    if which snap >/dev/null 2>&1; then
        \$SUDO snap remove nvim || true
    fi
    test -f ./nvim.appimage || curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.config/nvim/nvim.appimage
    \$SUDO chmod +x ./nvim.appimage
    test -f /usr/bin/nvim && \$SUDO mv /usr/bin/nvim /tmp/.nvim-executable-backup || true
    \$SUDO cp ./nvim.appimage /usr/bin/nvim
    /usr/bin/nvim --version || fix_nvim_appimage
elif [ "x\$(uname -s)\" = "xDarwin" ]; then
    echo \"-- MacOS detected, try installing latest nvim from brew...\"
    brew uninstall neovim 2> /dev/null || true
    brew install neovim
else
    if which pacman >/dev/null 2>&1; then
      pacman -S --noconfirm neovim
    else
      echo \"-- Non x86_64 Linux detected, trying snap for installing latest nvim...\"
      if ! which snap >/dev/null 2>&1; then
          echo \"-- Snap not found, try installing for you...\"
          if ! which apt >/dev/null 2>&1; then
            \$SUDO apt update -y || true
            \$SUDO apt install -y snapd || true
          elif ! which dnf >/dev/null 2>&1; then
            \$SUDO dnf install -y snapd || true
          elif ! which zypper >/dev/null 2>&1; then
            \$SUDO zypper in --no-confirm snapd || true
          fi
          \$SUDO systemctl enable --now snapd || true
      fi
      \$SUDO snap install nvim
    fi
fi
