#!/usr/bin/env bash
set -euo pipefail

# 基于脚本位置定位工作区根目录（scripts/ 的上一级）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# 清理 5000 端口残留进程（绝不碰 9000）
fuser -k 5000/tcp 2>/dev/null || true
sleep 1

# 启动 Spring Boot 服务，覆盖端口为 5000
exec java -Dserver.port=5000 -Dfile.encoding=UTF-8 -jar litemall-all/target/litemall-all-0.1.0-exec.jar
