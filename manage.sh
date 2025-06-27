#!/bin/bash

PROJECT_DIR="/root/memo-ai-proxy"

show_help() {
    echo "📋 Memo AI Proxy 管理工具"
    echo "================================"
    echo "用法: $0 <命令>"
    echo ""
    echo "🔧 服务管理:"
    echo "  start      启动服务"
    echo "  stop       停止服务"
    echo "  restart    重启服务"
    echo "  status     查看状态"
    echo ""
    echo "🛠️  开发工具:"
    echo "  build      构建项目"
    echo "  test       测试 API"
    echo "  logs       查看日志"
    echo ""
    echo "💡 示例:"
    echo "  $0 start      # 启动服务"
    echo "  $0 restart    # 重启服务"
    echo "  $0 test       # 测试 API"
    echo "  $0 logs       # 查看日志"
    echo "================================"
}

show_status() {
    echo "📊 服务状态"
    echo "================================"
    
    # 检查进程
    if pgrep -f "next-server" > /dev/null; then
        echo "🟢 服务状态: 运行中"
        echo "📍 进程信息:"
        ps aux | grep "next-server" | grep -v grep | awk '{print "   PID: " $2 ", CPU: " $3 "%, 内存: " $4 "%"}'
    else
        echo "🔴 服务状态: 未运行"
    fi
    
    # 检查端口
    echo "🔌 端口状态:"
    if netstat -tlnp | grep -q ":3000"; then
        echo "   ✅ 端口 3000 已监听"
        netstat -tlnp | grep ":3000"
    else
        echo "   ❌ 端口 3000 未监听"
    fi
    
    # 检查配置
    echo "⚙️  配置检查:"
    if [ -f "$PROJECT_DIR/.env" ]; then
        echo "   ✅ .env 文件存在"
    else
        echo "   ❌ .env 文件缺失"
    fi
    
    if [ -d "$PROJECT_DIR/.next" ]; then
        echo "   ✅ 项目已构建"
    else
        echo "   ⚠️  项目未构建"
    fi
    
    echo "================================"
}

case "$1" in
    start)
        $PROJECT_DIR/start.sh
        ;;
    stop)
        $PROJECT_DIR/stop.sh
        ;;
    restart)
        echo "🔄 重启服务..."
        $PROJECT_DIR/stop.sh
        sleep 2
        $PROJECT_DIR/build.sh
        $PROJECT_DIR/start.sh
        ;;
    status)
        show_status
        ;;
    build)
        $PROJECT_DIR/build.sh
        ;;
    test)
        $PROJECT_DIR/test.sh
        ;;
    logs)
        $PROJECT_DIR/logs.sh
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
