#!/bin/bash
# litemall 环境快速恢复脚本
# 环境重置后运行此脚本即可恢复所有服务

set -e

echo "=== 1. 检查并安装依赖 ==="
if ! command -v java &> /dev/null; then
    echo "安装 Java、Maven、MySQL..."
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq default-jdk maven mysql-server
fi

echo "=== 2. 启动 MySQL ==="
if ! pgrep -x mysqld > /dev/null; then
    mysqld_safe > /dev/null 2>&1 &
    sleep 3
    echo "MySQL 已启动"
else
    echo "MySQL 已在运行"
fi

echo "=== 3. 检查数据库 ==="
if ! mysql -u root -e "USE litemall" 2>/dev/null; then
    echo "初始化数据库..."
    mysql -u root < /workspace/projects/litemall-db/sql/litemall_schema.sql
    mysql -u root litemall < /workspace/projects/litemall-db/sql/litemall_table.sql
    mysql -u root litemall < /workspace/projects/litemall-db/sql/litemall_data.sql
    echo "数据库初始化完成"
else
    echo "数据库已存在"
fi

echo "=== 4. 启动后端服务 (端口 8080) ==="
if ! curl -s http://localhost:8080/admin/index/index > /dev/null 2>&1; then
    cd /workspace/projects
    nohup java -Dserver.port=8080 -Dfile.encoding=UTF-8 -jar litemall-all/target/litemall-all-0.1.0-exec.jar > /tmp/backend.log 2>&1 &
    sleep 10
    echo "后端服务已启动"
else
    echo "后端服务已在运行"
fi

echo "=== 5. 启动前端 dev server (端口 5000) ==="
if ! curl -s http://localhost:5000/ > /dev/null 2>&1; then
    cd /workspace/projects/litemall-admin
    nohup npx vue-cli-service serve --host=0.0.0.0 --port=5000 > /tmp/frontend.log 2>&1 &
    sleep 15
    echo "前端 dev server 已启动"
else
    echo "前端 dev server 已在运行"
fi

echo ""
echo "=== 恢复完成 ==="
echo "前端预览: http://localhost:5000"
echo "后端 API: http://localhost:8080"
echo "管理员账号: admin123 / admin123"
