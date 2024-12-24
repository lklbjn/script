#!/bin/bash

# 检查是否具有 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 用户权限运行此脚本。"
  exit 1
fi

# 函数：编译安装 btop
compile_install() {
  echo "开始编译安装 btop..."
  
  # 安装依赖
  echo "安装必要的依赖..."
  if command -v apt &>/dev/null; then
    sudo apt update -y
    sudo apt install -y git build-essential gcc make
  elif command -v yum &>/dev/null; then
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y git
  elif command -v dnf &>/dev/null; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y git
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm base-devel git
  else
    echo "无法检测到支持的包管理器。请手动安装依赖。"
    exit 1
  fi

  # 下载并编译安装 btop
  cd /tmp
  echo "克隆 btop 源码..."
  git clone https://github.com/aristocratos/btop.git
  cd btop
  echo "开始编译 btop..."
  make
  sudo make install

  # 检查是否安装成功
  if command -v btop &>/dev/null; then
    echo "btop 编译安装成功！运行 'btop' 启动。"
  else
    echo "btop 编译安装失败，请检查错误日志。"
  fi
}

# 函数：二进制安装 btop
binary_install() {
  echo "开始二进制安装 btop..."

  # 自动检测架构
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)
      ARCH="x86_64"
      ;;
    aarch64 | arm64)
      ARCH="arm64"
      ;;
    *)
      echo "未支持的架构：$ARCH"
      exit 1
      ;;
  esac

  # 检查并安装 bzip2（依赖）
  echo "检查是否安装 bzip2..."
  if ! command -v bzip2 &>/dev/null; then
    echo "bzip2 未安装，正在安装..."
    if command -v apt &>/dev/null; then
      sudo apt update -y
      sudo apt install -y bzip2
    elif command -v yum &>/dev/null; then
      sudo yum install -y bzip2
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y bzip2
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm bzip2
    else
      echo "无法检测到支持的包管理器，请手动安装 bzip2。"
      exit 1
    fi
  fi

  # 下载二进制文件
  echo "检测到架构：$ARCH"
  VERSION=$(curl -s https://api.github.com/repos/aristocratos/btop/releases/latest | grep "tag_name" | cut -d '"' -f 4)
  echo "最新版本：$VERSION"
  DOWNLOAD_URL="https://github.com/aristocratos/btop/releases/download/$VERSION/btop-$ARCH-linux-musl.tbz"
  echo "下载地址：$DOWNLOAD_URL"

  cd /tmp
  curl -LO "$DOWNLOAD_URL"

  # 解压并安装
  echo "解压并安装 btop-$ARCH-linux-musl.tbz"
  tar -xjf btop-$ARCH-linux-musl.tbz
  sudo mv btop/bin/btop /usr/local/bin/
  sudo chmod +x /usr/local/bin/btop

  # 检查是否安装成功
  if command -v btop &>/dev/null; then
    echo "btop 二进制安装成功！运行 'btop' 启动。"
  else
    echo "btop 二进制安装失败，请检查错误日志。"
  fi
}

# 函数：通过 Homebrew 安装 btop
homebrew_install() {
  echo "开始通过 Homebrew 安装 btop..."

  # 安装 Homebrew
  if ! command -v brew &>/dev/null; then
    echo "Homebrew 未安装，开始安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  # 使用 Homebrew 安装 btop
  brew install btop

  # 检查是否安装成功
  if command -v btop &>/dev/null; then
    echo "btop 通过 Homebrew 安装成功！运行 'btop' 启动。"
  else
    echo "btop 安装失败，请检查错误日志。"
  fi
}

# 主程序：选择安装方式
echo "请选择安装方式："
echo "1) 编译安装"
echo "2) 二进制安装(没有GPU支持)"
echo "3) Homebrew 安装"
read -p "请输入选项 (1/2/3): " choice

# 如果没有输入，默认选择 2（二进制安装）
if [ -z "$choice" ]; then
  choice=2
fi

case "$choice" in
  1)
    compile_install
    ;;
  2)
    binary_install
    ;;
  3)
    homebrew_install
    ;;
  *)
    echo "无效选项，请重新运行脚本并选择 1、2 或 3。"
    binary_install
    ;;
esac
