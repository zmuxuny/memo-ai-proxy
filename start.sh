#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"
LOG_FILE="$PROJECT_DIR/app.log"

echo "🚀 启动 Memo AI Proxy 服务..."

cd $PROJECT_DIR

# 检查是否已有服务运行
if pgrep -f "next-server" > /dev/null; then
    echo "⚠️  服务已在运行"
    ps aux | grep "next-server" | grep -v grep
    exit 0
fi

# 检查环境文件
if [ ! -f ".env" ]; then
    echo "❌ 未找到 .env 文件"
    echo "请复制 .env.example 为 .env 并配置 API 密钥"
    exit 1
fi

# 启动服务
echo "正在启动服务..."
nohup npm start > $LOG_FILE 2>&1 &

# 等待启动
sleep 5

# 检查启动状态
if pgrep -f "next-server" > /dev/null; then
    echo "✅ 服务启动成功"
    echo "📍 本地地址: http://localhost:3000"
    echo "🌐 外网地址: http://120.46.35.101:3000"
    echo "📋 查看日志: ./logs.sh"
else
    echo "❌ 服务启动失败，请查看日志"
    tail -10 $LOG_FILE
fi
