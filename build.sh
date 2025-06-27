#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"

echo "🔨 构建 Memo AI Proxy 项目..."

cd $PROJECT_DIR

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ 依赖安装失败"
        exit 1
    fi
fi

# 构建项目
echo "🏗️  开始构建..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功"
else
    echo "❌ 构建失败"
    exit 1
fi
