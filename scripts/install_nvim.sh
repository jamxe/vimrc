#!/bin/bash
set -e

echo "-- NeoVim 0.9.1 or above not found, installing latest for you."

cd "$(dirname $0)"

get_linux_distro() {
    if grep -Eq "Ubuntu" /etc/*-release 2> /dev/null; then
        echo "Ubuntu"
    elif grep -Eq "Deepin" /etc/*-release 2> /dev/null; then
        echo "Deepin"
    elif grep -Eq "Raspbian" /etc/*-release 2> /dev/null; then
        echo "Raspbian"
    elif grep -Eq "uos" /etc/*-release 2> /dev/null; then
        echo "UOS"
    elif grep -Eq "LinuxMint" /etc/*-release 2> /dev/null; then
        echo "LinuxMint"
    elif grep -Eq "elementary" /etc/*-release 2> /dev/null; then
        echo "elementaryOS"
    elif grep -Eq "Debian" /etc/*-release 2> /dev/null; then
        echo "Debian"
    elif grep -Eq "Kali" /etc/*-release 2> /dev/null; then
        echo "Kali"
    elif grep -Eq "Parrot" /etc/*-release 2> /dev/null; then
        echo "Parrot"
    elif grep -Eq "CentOS" /etc/*-release 2> /dev/null; then
        echo "CentOS"
    elif grep -Eq "fedora" /etc/*-release 2> /dev/null; then
        echo "fedora"
    elif grep -Eq "openSUSE" /etc/*-release 2> /dev/null; then
        echo "openSUSE"
    elif grep -Eq "Arch Linux" /etc/*-release 2> /dev/null; then
        echo "ArchLinux"
    elif grep -Eq "ManjaroLinux" /etc/*-release 2> /dev/null; then
        echo "ManjaroLinux"
    elif grep -Eq "Gentoo" /etc/*-release 2> /dev/null; then
        echo "Gentoo"
    elif grep -Eq "alpine" /etc/*-release 2> /dev/null; then
        echo "Alpine"
    elif [ "x$(uname -s)" = "xDarwin" ]; then
        echo "MacOS"
    else
        echo "Unknown"
    fi
}

detect_platform() {
  local platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  # check for MUSL
  if [ "${platform}" = "linux" ]; then
    if ldd /bin/sh | grep -i musl >/dev/null; then
      platform=linux_musl
    fi
  fi

  # mingw is Git-Bash
  if echo "${platform}" | grep -i mingw >/dev/null; then
    platform=win
  fi

  echo "${platform}"
}

detect_arch() {
  local arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

  if echo "${arch}" | grep -i arm >/dev/null; then
    # ARM is fine
    echo "${arch}"
  else
    if [ "${arch}" = "i386" ]; then
      arch=x86
    elif [ "${arch}" = "x86_64" ]; then
      arch=x64
    elif [ "${arch}" = "aarch64" ]; then
      arch=arm64
    fi

    # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
    if [ "${arch}" = "x64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
      arch=x86
    fi

    echo "${arch}"
  fi
}

install_snap() {
    if ! which apt >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt update -y || true
        sudo apt install -y snapd || true
    elif ! which zypper >/dev/null 2>&1; then
        sudo zypper in --no-confirm snapd || true
    elif ! which dnf >/dev/null 2>&1; then
        sudo dnf install -y epel-release || true
        sudo dnf upgrade || true
        sudo dnf install -y snapd || true
    elif ! which yum >/dev/null 2>&1; then
        sudo yum install -y epel-release || true
        sudo yum install -y snapd || true
    fi
    sudo systemctl enable --now snapd || true
}

fix_nvim_appimage() {
    sudo mv /usr/bin/nvim /usr/bin/.nvim.appimage.noextract
    echo 'x=$$; mkdir -p /tmp/_nvim_appimg_.$x && bash -c "cd /tmp/_nvim_appimg_.$x && /usr/bin/.nvim.appimage.noextract --appimage-extract > /dev/null 2>&1" && /tmp/_nvim_appimg_.$x/squashfs-root/AppRun "$@"; x=$?; rm -rf /tmp/_nvim_appimg_.$x exit $x' | sudo tee /usr/bin/nvim
    sudo chmod +x /usr/bin/nvim
    # echo exec \"\$@\" > /bin/sudo; chmod +x /bin/sudo
}

if [ "x$(uname -sm)" = "xLinux x86_64" ]; then
    if which snap >/dev/null 2>&1; then
        sudo snap remove nvim || true
    fi
    test -f ./nvim.appimage || curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.config/nvim/nvim.appimage
    sudo chmod +x ./nvim.appimage
    test -f /usr/bin/nvim && sudo mv /usr/bin/nvim /tmp/.nvim-executable-backup || true
    sudo cp ./nvim.appimage /usr/bin/nvim
    /usr/bin/nvim --version || fix_nvim_appimage
elif [ "x$(uname -s)" = "xDarwin" ]; then
    echo "-- MacOS detected, try installing latest nvim from brew..."
    brew uninstall neovim 2> /dev/null || true
    brew install neovim
else
    if which pacman >/dev/null 2>&1; then
      echo "-- Installing latest nvim with pacman..."
      pacman -S --noconfirm neovim
    else
      echo "-- Non x86_64 Linux detected, trying installing latest nvim from snap..."
      if ! which snap >/dev/null 2>&1; then
          echo "-- Snap not found, try installing for you..."
          install_snap
      fi
      sudo snap install nvim
    fi
fi
