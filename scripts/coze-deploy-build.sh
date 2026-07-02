#!/usr/bin/env bash
set -euo pipefail

# 基于脚本位置定位工作区根目录（scripts/ 的上一级）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# 构建管理后台前端
cd "$PROJECT_DIR/litemall-admin"
pnpm install
pnpm run build:dep

# 构建移动端前端
cd "$PROJECT_DIR/litemall-vue"
pnpm install
pnpm run build:dep

# 构建后端 JAR
cd "$PROJECT_DIR"
mvn clean package -DskipTests
