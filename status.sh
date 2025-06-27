#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"

echo "=== Memo AI Proxy 服务状态 ==="
echo "时间: $(date)"
echo ""

echo "进程状态:"
ps aux | grep node | grep -v grep

echo ""
echo "端口监听:"
netstat -tlnp | grep 3000

echo ""
echo "最新日志 (最后10行):"
tail -10 $PROJECT_DIR/app.log

echo ""
echo "API测试:"
curl -s -X POST http://localhost:3000/api/summarize \
  -H "Content-Type: application/json" \
  -d '{"content": "状态检查"}' \
  --max-time 5
echo ""
