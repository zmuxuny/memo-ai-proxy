#!/bin/bash

echo "🛑 停止 Memo AI Proxy 服务..."

# 查找并停止进程
if pgrep -f "next-server" > /dev/null; then
    echo "正在停止服务..."
    pkill -f "next-server"
    
    # 等待进程结束
    sleep 3
    
    # 检查是否完全停止
    if pgrep -f "next-server" > /dev/null; then
        echo "强制停止进程..."
        pkill -9 -f "next-server"
    fi
    
    echo "✅ 服务已停止"
else
    echo "ℹ️  服务未运行"
fi
