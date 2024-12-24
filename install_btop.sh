#!/bin/bash

# 检查是否具有 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户权限运行此脚本。"
  exit 1
fi

# 更新软件包索引
echo "更新软件包索引..."
sudo apt update -y || sudo yum makecache -y || sudo dnf makecache -y || sudo pacman -Sy

# 检查系统发行版并安装依赖
echo "安装必要的依赖..."
if command -v apt &>/dev/null; then
  sudo apt install -y git build-essential gcc make
elif command -v yum &>/dev/null; then
  sudo yum groupinstall -y "Development Tools"
elif command -v dnf &>/dev/null; then
  sudo dnf groupinstall -y "Development Tools"
elif command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm base-devel
else
  echo "无法检测到支持的包管理器。请手动安装依赖。"
  exit 1
fi

# 安装 lowdown
echo "开始安装 lowdown..."
cd /tmp
git clone https://github.com/kristapsdz/lowdown.git
cd lowdown
make
sudo make install

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
