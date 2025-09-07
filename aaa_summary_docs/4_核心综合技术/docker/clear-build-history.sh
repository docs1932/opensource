#!/bin/bash
echo "🧹 正在清理 Docker 构建历史..."

# 清理构建缓存（中间层）
echo "🗑️ 删除构建缓存..."
docker builder prune -a -f

# 清理 BuildKit 缓存
echo "🗑️ 删除 BuildKit 缓存..."
docker buildx prune -a -f

# 清理悬空镜像
echo "🗑️ 删除悬空镜像..."
docker image prune -a -f

# 可选：清理系统垃圾（网络、容器等）
echo "🧹 清理系统垃圾..."
docker system prune -f

echo "✅ 所有 Docker 构建历史已清除！"
