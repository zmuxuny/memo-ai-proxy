#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"

echo "================================"
echo "🔄 重启 Memo AI Proxy 服务"
echo "⏰ 时间: $(date)"
echo "================================"

# 进入项目目录
cd $PROJECT_DIR

echo "第一步: 停止服务"
if [ -f "$PROJECT_DIR/stop.sh" ]; then
    $PROJECT_DIR/stop.sh
else
    echo "⚠️  stop.sh 不存在，手动停止进程..."
    pkill -f "next-server"
fi

echo ""
echo "第二步: 重新构建"
echo "🔨 开始构建项目..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ 构建失败！"
    echo "请检查项目配置和依赖"
    exit 1
fi
echo "✅ 构建成功"

echo ""
echo "第三步: 启动服务"
if [ -f "$PROJECT_DIR/start.sh" ]; then
    $PROJECT_DIR/start.sh
else
    echo "⚠️  start.sh 不存在，手动启动..."
    nohup npm start > app.log 2>&1 &
    sleep 3
    if pgrep -f "next-server" > /dev/null; then
        echo "✅ 服务启动成功"
    else
        echo "❌ 服务启动失败"
        exit 1
    fi
fi

echo ""
echo "第四步: 验证服务"
sleep 5
if pgrep -f "next-server" > /dev/null; then
    echo "✅ 服务运行正常"
    echo "📍 本地: http://localhost:3000"
    echo "🌐 外网: http://120.46.35.101:3000"
    
    # 快速测试API
    echo "🧪 快速测试API..."
    response=$(curl -s -X POST http://localhost:3000/api/summarize \
      -H "Content-Type: application/json" \
      -d '{"content": "重启测试"}' \
      --max-time 5)
    
    if [[ $response == *"summary"* ]]; then
        echo "✅ API测试通过"
    else
        echo "⚠️  API测试失败，请手动检查"
    fi
else
    echo "❌ 服务启动失败"
    echo "📋 请查看日志: tail -f app.log"
    exit 1
fi

echo "================================"
echo "🎉 重启完成！"
echo "================================"
