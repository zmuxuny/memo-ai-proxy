# Docker 部署指南

## 快速部署

### 1. 克隆代码
```bash
git clone <您的仓库地址>
cd memo-ai-proxy
```

### 2. 设置环境变量
```bash
cp .env.example .env
nano .env  # 编辑文件，设置您的 DeepSeek API 密钥
```

### 3. 构建并启动
```bash
# 方法1: 使用脚本（推荐）
chmod +x deploy.sh
./deploy.sh

# 方法2: 手动执行
docker-compose up -d --build
```

### 4. 验证部署
```bash
# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 测试API
curl -X POST http://localhost:3000/api/summarize \
  -H "Content-Type: application/json" \
  -d '{"content": "测试内容"}'
```

## 管理命令

```bash
# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 查看日志
docker-compose logs -f

# 更新代码后重新部署
git pull
docker-compose up -d --build

# 清理未使用的镜像
docker image prune -f
```

## 使用 Nginx 反向代理（可选）

如果想通过80端口访问，可以启用 nginx：

```bash
docker-compose --profile with-nginx up -d --build
```

这样可以通过 http://您的服务器IP 直接访问，无需端口号。

## 故障排除

### 容器无法启动
```bash
# 查看详细日志
docker-compose logs memo-ai-proxy

# 检查构建过程
docker-compose up --build
```

### API 返回 500 错误
- 检查环境变量是否正确设置
- 确认 DeepSeek API 密钥有效
- 查看容器日志排查错误

### 端口冲突
如果 3000 端口被占用，可以修改 docker-compose.yml：
```yaml
ports:
  - "3001:3000"  # 改为其他端口
```
