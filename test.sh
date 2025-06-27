#!/bin/bash

echo "🧪 测试 Memo AI Proxy API..."

BASE_URL="http://localhost:3000"

# 检查服务是否运行
if ! nc -z localhost 3000 2>/dev/null; then
    echo "❌ 服务未运行，请先启动服务"
    echo "运行: ./start.sh"
    exit 1
fi

echo ""
echo "1️⃣  测试总结 API..."
response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST $BASE_URL/api/summarize \
  -H "Content-Type: application/json" \
  -d '{"content": "这是一个测试内容，用于验证总结功能是否正常工作。"}' \
  --max-time 10)

http_code=$(echo $response | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
response_body=$(echo $response | sed 's/HTTPSTATUS:[0-9]*$//')

if [ "$http_code" = "200" ]; then
    echo "✅ 总结 API 正常"
    echo "   响应: $response_body"
else
    echo "❌ 总结 API 失败 (状态码: $http_code)"
fi

echo ""
echo "2️⃣  测试聊天 API..."
response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST $BASE_URL/api/chat \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "你好"}]}' \
  --max-time 5)

http_code=$(echo $response | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)

if [ "$http_code" = "200" ]; then
    echo "✅ 聊天 API 正常 (流式响应)"
else
    echo "❌ 聊天 API 失败 (状态码: $http_code)"
fi

echo ""
echo "3️⃣  测试 CORS 配置..."
cors_response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X OPTIONS $BASE_URL/api/summarize \
  -H "Origin: http://120.46.35.101:3001" \
  -H "Access-Control-Request-Method: POST" \
  --max-time 5)

cors_code=$(echo $cors_response | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)

if [ "$cors_code" = "200" ]; then
    echo "✅ CORS 配置正常"
else
    echo "⚠️  CORS 配置可能有问题"
fi

echo ""
echo "🌐 API 地址:"
echo "   总结: http://120.46.35.101:3000/api/summarize"
echo "   聊天: http://120.46.35.101:3000/api/chat"
echo ""
echo "✨ 测试完成"
