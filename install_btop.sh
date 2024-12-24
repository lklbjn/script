#!/bin/bash

# 检查是否具有 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户权限运行此脚本。"
  exit 1
fi

# 更新软件包索引并安装必要的依赖
echo "更新软件包索引并安装必要的依赖..."
if command -v apt &>/dev/null; then
  sudo apt update -y
  sudo apt install -y build-essential procps curl file git
elif command -v yum &>/dev/null; then
  sudo yum install -y gcc gcc-c++ make procps-ng curl file git
elif command -v dnf &>/dev/null; then
  sudo dnf install -y gcc gcc-c++ make procps-ng curl file git
elif command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm base-devel procps-ng curl file git
else
  echo "无法检测到支持的包管理器。请手动安装依赖。"
  exit 1
fi

# 安装 Homebrew
echo "安装 Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 配置 Homebrew 环境变量
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 使用 Homebrew 安装 btop
echo "使用 Homebrew 安装 btop..."
brew install btop

# 检查 btop 是否安装成功
if command -v btop &>/dev/null; then
  echo "btop 安装成功！运行 'btop' 启动。"
else
  echo "btop 安装失败，请检查错误日志。"
fi
