#!/bin/sh

# 检查nezha-agent进程是否存在
if pgrep -x "nezha-agent" > /dev/null; then
    # 进程存在，输出信息
    echo "$(date): nezha-agent is running" >> /opt/nezha/agent/nezha_monitor.log
else
    # 进程不存在，进入程序目录（根据实际情况调整路径）
    cd /opt/nezha/agent
    # 重启命令（使用绝对路径更可靠）
    nohup ./nezha-agent -s nezha.baidu.cc:5555 -p ahzkjhxoqaojzlkxcl >> /root/home/log/nezha.info 2>&1 &
    # 记录重启时间
    echo "$(date): nezha-agent restarted" >> /opt/nezha/agent/nezha_restart.log
fi
