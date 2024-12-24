#!/bin/bash

# 检查是否具有 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户权限运行此脚本。"
  exit 1
fi

# 更新软件包索引
echo "更新软件包索引..."
if command -v apt &>/dev/null; then
  sudo apt update -y
elif command -v yum &>/dev/null; then
  sudo yum makecache -y
elif command -v dnf &>/dev/null; then
  sudo dnf makecache -y
elif command -v pacman &>/dev/null; then
  sudo pacman -Sy
else
  echo "无法检测到支持的包管理器。请手动安装依赖。"
  exit 1
fi

# 安装必要的依赖
echo "安装必要的依赖..."
if command -v apt &>/dev/null; then
  sudo apt install -y git build-essential gcc make curl
elif command -v yum &>/dev/null; then
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y git curl
elif command -v dnf &>/dev/null; then
  sudo dnf groupinstall -y "Development Tools"
  sudo dnf install -y git curl
elif command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm base-devel git curl
else
  echo "无法检测到支持的包管理器。请手动安装依赖。"
  exit 1
fi

# 安装 lowdown
echo "尝试通过包管理器安装 lowdown..."
if command -v apt &>/dev/null; then
  if ! sudo apt install -y lowdown; then
    echo "通过 apt 安装 lowdown 失败，尝试从源码安装..."
    cd /tmp
    git clone https://github.com/kristapsdz/lowdown.git
    cd lowdown
    ./configure
    make
    sudo make install
  fi
elif command -v yum &>/dev/null || command -v dnf &>/dev/null; then
  echo "目前 yum/dnf 没有直接支持 lowdown 的包，尝试从源码安装..."
  cd /tmp
  git clone https://github.com/kristapsdz/lowdown.git
  cd lowdown
  ./configure
  make
  sudo make install
else
  echo "无法通过包管理器安装 lowdown，尝试从源码安装..."
  cd /tmp
  git clone https://github.com/kristapsdz/lowdown.git
  cd lowdown
  ./configure
  make
  sudo make install
fi

# 检查 lowdown 是否安装成功
if ! command -v lowdown &>/dev/null; then
  echo "lowdown 安装失败，请检查错误日志。"
  exit 1
fi

# 下载并安装 btop
echo "开始安装 btop..."
cd /tmp
git clone https://github.com/aristocratos/btop.git
cd btop
make
sudo make install

# 检查 btop 是否安装成功
if command -v btop &>/dev/null; then
  echo "btop 安装成功！运行 'btop' 启动。"
else
  echo "btop 安装失败，请检查错误日志。"
fi
