#!/bin/bash
set -e

echo '-- Automatically installing ArchVim system dependencies...'

cd "$(dirname $0)"
# --version > /dev/null 2> /dev/null && SUDO=|| SUDO=

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

pcall() {
    "$@"
    echo -- ERROR: failed to install: "$@"
}

ensure_pip() {
    python="$(which python3 || which python)"
    if ! $python -m pip --version 2> /dev/null; then
        (curl --connect-timeout 8 https://bootstrap.pypa.io/get-pip.py | $python) || true
    fi
    if ! $python -m pip --version 2> /dev/null; then
        pcall $python -m ensurepip
    fi
    pcall $python -m pip --version
}

install_pacman() {
    pcall pacman -S --noconfirm ripgrep
    pcall pacman -S --noconfirm fzf
    pacman -S --noconfirm cmake
    pacman -S --noconfirm make
    pacman -S --noconfirm git
    pacman -S --noconfirm gcc
    pacman -S --noconfirm python
    pacman -S --noconfirm python-pip
    pacman -S --noconfirm curl
    pacman -S --noconfirm clang
    pacman -S --noconfirm nodejs
    pacman -S --noconfirm npm
    pacman -S --noconfirm lua-language-server
    pacman -S --noconfirm pyright
    pacman -S --noconfirm python-pynvim
    pacman -S --noconfirm python-openai
}

install_apt() {
    export DEBIAN_FRONTEND=noninteractive
    apt update
    pcall apt-get install -y ripgrep
    pcall apt-get install -y fzf
    apt-get install -y cmake
    apt-get install -y make
    apt-get install -y git
    apt-get install -y gcc
    apt-get install -y python3
    apt-get install -y python3-pip
    apt-get install -y curl
    pcall apt-get install -y clangd
    pcall apt-get install -y clang-format
    pcall apt-get install -y nodejs
    pcall apt-get install -y npm
    python="$(which python3 || which python)"
    if "$python" -m pip install --help | grep break-system-packages; then
        break="--break-system-packages"
    else
        break=
    fi
    ensure_pip
    pcall "$python" -m pip install -U pyright $break
    pcall "$python" -m pip install -U pynvim $break
    pcall "$python" -m pip install -U openai $break
}

install_yum() {
    yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    pcall yum install -y ripgrep
    pcall yum install -y fzf
    yum install -y cmake
    yum install -y make
    yum install -y git
    yum install -y gcc
    yum install -y python3 || yum install -y python
    yum install -y curl
    pcall yum install -y clangd
    pcall yum install -y clang-format
    pcall yum install -y nodejs
    pcall yum install -y npm
    ensure_pip
    python="$(which python3 || which python)"
    pcall "$python" -m pip install -U pyright
    pcall "$python" -m pip install -U pynvim
    pcall "$python" -m pip install -U openai
}


install_brew() {
    pcall brew install ripgrep
    pcall brew install fzf
    brew install cmake
    brew install make
    brew install git
    brew install gcc
    brew install python
    brew install curl
    pcall brew install clangd
    pcall brew install clang-format
    pcall brew install node
    pcall brew install npm
    pcall brew install lua-language-server
    ensure_pip
    python="$(which python3 || which python)"
    pcall "$python" -m pip install -U pyright
    pcall "$python" -m pip install -U pynvim
    pcall "$python" -m pip install -U openai
}


install_dnf() {
    pcall dnf install -y ripgrep
    pcall dnf install -y fzf
    dnf install -y cmake
    dnf install -y make
    dnf install -y git
    dnf install -y gcc
    dnf install -y python3 || dnf install -y python
    dnf install -y curl
    pcall dnf install -y clangd
    pcall dnf install -y clang-format
    pcall dnf install -y nodejs
    pcall dnf install -y npm
    ensure_pip
    python="$(which python3 || which python)"
    pcall "$python" -m pip install -U pyright
    pcall "$python" -m pip install -U pynvim
    pcall "$python" -m pip install -U openai
}

install_zypper() {
    pcall zypper in --no-confirm ripgrep || true
    pcall zypper in --no-confirm fzf || true
    zypper in --no-confirm cmake
    zypper in --no-confirm make
    zypper in --no-confirm git
    zypper in --no-confirm gcc
    zypper in --no-confirm python
    zypper in --no-confirm curl
    pcall zypper in --no-confirm clangd
    pcall zypper in --no-confirm clang-format
    pcall zypper in --no-confirm nodejs
    pcall zypper in --no-confirm npm
    ensure_pip
    python="$(which python3 || which python)"
    pcall "$python" -m pip install -U pyright
    pcall "$python" -m pip install -U pynvim
    pcall "$python" -m pip install -U openai
}

do_install() {
    distro=`get_linux_distro`
    echo "-- Linux distro detected: $distro"

    if [ $distro = "Ubuntu" ]; then
        install_apt
    elif [ $distro = "Deepin" ]; then
        install_apt
    elif [ $distro = "Debian" ]; then
        install_apt
    elif [ $distro = "Kali" ]; then
        install_apt
    elif [ $distro = "Raspbian" ]; then
        install_apt
    elif [ $distro = "ArchLinux" ]; then
        install_pacman
    elif [ $distro = "ManjaroLinux" ]; then
        install_pacman
    elif [ $distro = "MacOS" ]; then
        install_brew
    elif [ $distro = "fedora" ]; then
        install_dnf
    elif [ $distro = "openSUSE" ]; then
        install_zypper
    elif [ $distro = "CentOS" ]; then
        install_yum
    else
        # TODO: add more Linux distros here..
        echo "-- WARNING: Unsupported Linux distro: $distro"
        echo "-- The script will not install any dependent packages like clangd."
        echo "-- You will have to manually install clangd, if you plan to make a working C++ IDE."
        echo "-- If you know how to install them, feel free to contribute to this GitHub repository: github.com/archibate/vimrc"
        exit 1
    fi

    echo "-- System dependency installation complete!"
}

do_install
