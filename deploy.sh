#!/bin/bash

# Docker部署脚本

echo "开始部署 Memo AI Proxy..."

# 检查是否存在 .env 文件
if [ ! -f .env ]; then
    echo "错误: 请先创建 .env 文件并设置 OPENAI_API_KEY"
    echo "可以复制 .env.example 并修改："
    echo "cp .env.example .env"
    echo "然后编辑 .env 文件设置您的API密钥"
    exit 1
fi

# 停止现有容器
echo "停止现有容器..."
docker-compose down

# 构建并启动新容器
echo "构建并启动新容器..."
docker-compose up -d --build

# 检查状态
echo "检查容器状态..."
docker-compose ps

echo "部署完成！"
echo "应用将在以下地址运行："
echo "- 直接访问: http://localhost:3000"
echo "- API端点:"
echo "  - http://localhost:3000/api/chat"
echo "  - http://localhost:3000/api/summarize"
echo ""
echo "查看日志: docker-compose logs -f"
echo "停止服务: docker-compose down"
