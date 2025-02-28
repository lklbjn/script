#!/bin/sh

# 检查nezha-agent进程是否存在
if ! pgrep -x "nezha-agent" > /dev/null; then
    # 进入程序目录（根据实际情况调整路径）
    cd /root
    # 重启命令（使用绝对路径更可靠）
    nohup ./nezha-agent -s nezha.baidu.cc:5555 -p ahzkjhxoqaojzlkxcl >> /root/home/log/nezha.info 2>&1 &
    # 记录重启时间（可选）
    echo "$(date): nezha-agent restarted" >> /root/nezha_restart.log
fi
