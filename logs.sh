#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"
LOG_FILE="$PROJECT_DIR/app.log"

case "$1" in
    ""|tail)
        echo "📄 实时查看日志 (按 Ctrl+C 退出)..."
        tail -f $LOG_FILE
        ;;
    last)
        lines=${2:-20}
        echo "📄 显示最新 $lines 行日志..."
        tail -$lines $LOG_FILE
        ;;
    clear)
        echo "🗑️  清空日志..."
        > $LOG_FILE
        echo "✅ 日志已清空"
        ;;
    *)
        echo "📋 日志管理工具"
        echo "用法: $0 [命令]"
        echo ""
        echo "命令:"
        echo "  (无参数) 或 tail    - 实时查看日志"
        echo "  last [行数]         - 查看最新日志 (默认20行)"
        echo "  clear              - 清空日志"
        echo ""
        echo "示例:"
        echo "  $0                 # 实时日志"
        echo "  $0 last 50         # 最新50行"
        echo "  $0 clear           # 清空日志"
        ;;
esac
