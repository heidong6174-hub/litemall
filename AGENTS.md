## 项目概述

litemall - 又一个小商场系统。全栈电商项目，包含管理后台、移动端商城和微信小程序三个前端，以及 Java 后端服务。

## 技术栈

- **后端**: Spring Boot 2.1.5, MyBatis, Shiro, MySQL, JDK 1.8, Maven
- **管理后台 (litemall-admin)**: Vue 2 + Element UI, vue-cli-service
- **移动端 (litemall-vue)**: Vue 2 + Vant, vue-cli-service
- **微信小程序 (litemall-wx)**: 原生小程序开发
- **包管理**: 前端使用 pnpm（平台约束），后端使用 Maven

## 目录结构

```
/workspace/projects/
├── litemall-admin/       # Vue 管理后台（Element UI）
├── litemall-vue/         # Vue 移动端商城（Vant）
├── litemall-wx/          # 微信小程序前端
├── renard-wx/            # 另一个微信小程序版本
├── litemall-core/        # 核心业务模块（Java）
├── litemall-db/          # 数据库模块（MyBatis + SQL）
├── litemall-wx-api/      # 微信小程序 API
├── litemall-admin-api/   # 管理后台 API
├── litemall-all/         # 后端打包模块（JAR）
├── litemall-all-war/     # 后端打包模块（WAR）
├── deploy/               # 部署脚本和配置
├── docker/               # Docker 配置
└── doc/                  # 项目文档
```

## 关键入口 / 核心模块

- **管理后台入口**: `litemall-admin/src/main.js`，开发命令 `pnpm dev`
- **移动端入口**: `litemall-vue/src/main.js`，开发命令 `pnpm dev`
- **后端入口**: `litemall-all` 模块，打包为 `litemall-all-0.1.0-exec.jar`
- **数据库脚本**: `litemall-db/sql/` 下的 schema/table/data SQL 文件

## 运行与预览

- 沙箱环境默认仅有 Node.js 24；Java/Maven/MySQL 可通过 apt-get 安装
- 前端子项目（litemall-admin、litemall-vue）可独立安装依赖并启动开发服务器
- 后端服务需要 MySQL + JDK 环境，已验证可通过 apt-get 安装并运行
- 前端开发服务器默认端口需代理到后端 API（见各 .env.development 配置）

### 后端部署

- MySQL 8.0 通过 `apt-get install mysql-server` 安装，`service mysql start` 启动
- JDK 通过 `apt-get install default-jdk maven` 安装（实际为 OpenJDK 21，向下兼容 JDK 1.8）
- 数据库初始化：依次执行 `litemall-db/sql/` 下的 `litemall_schema.sql`、`litemall_table.sql`、`litemall_data.sql`
- 数据库连接：`litemall` / `litemall123456`（见 `litemall-db/src/main/resources/application-db.yml`）
- Maven 构建：`mvn clean package -DskipTests`，产物为 `litemall-all/target/litemall-all-0.1.0-exec.jar`
- 前端构建需在 Maven 打包前完成（`pnpm run build`），产物复制到 JAR 的 `static/` 目录
- 启动命令：`java -Dserver.port=5000 -jar litemall-all/target/litemall-all-0.1.0-exec.jar`
- 管理员账号：`admin123` / `admin123`

### 前端构建注意事项

- litemall-admin 使用 pnpm 时存在依赖提升问题，需额外安装 `vue-loader@15`（Vue 2 兼容版本）和 `qs`
- `svg-baker-runtime` 已作为 `svg-sprite-loader` 的依赖安装，但 pnpm 严格模式下可能需要显式安装
- 构建命令：`pnpm run build`（production）或 `pnpm run build:dep`（deployment）

### 预览链路

- 项目被判定为 Web 预览型项目（存在 Vue 管理后台和移动端前端）
- 预览入口：litemall-admin（Vue 2 + Element UI 管理后台）
- 预览脚本：`scripts/coze-preview-build.sh`（安装依赖）、`scripts/coze-preview-run.sh`（启动 dev server）
- 根 `.coze` 的 `[dev]` 调用上述脚本，脚本内部 cd 到 `litemall-admin/` 执行
- 预览服务绑定 `0.0.0.0:5000`；后端运行在 8080 端口，前端通过代理转发 `/admin` 请求到后端
- litemall-admin 使用 pnpm 时需额外安装 `vue-loader@15`、`qs`
- vue-cli-service 支持 `--host` 和 `--port` 参数透传

### 环境重置后快速恢复

环境重置是平台行为，无法阻止。重置后运行以下脚本可一键恢复所有服务：

```bash
bash /workspace/projects/scripts/restore-services.sh
```

该脚本会：
1. 检查并安装 Java、Maven、MySQL（如未安装）
2. 启动 MySQL 并初始化数据库（如未初始化）
3. 启动后端 Java 服务（端口 8080）
4. 启动前端 dev server（端口 5000）

**服务架构**：
- 前端 dev server（5000 端口）提供页面，通过代理将 `/admin` API 请求转发到后端（8080 端口）
- 后端 Java 服务（8080 端口）提供 API 和数据库访问
- MySQL 数据库存储业务数据

### 部署链路

- 部署类型：service / web
- 运行时：nodejs-24（前端构建）+ java-17（后端运行）
- 部署脚本：`scripts/coze-deploy-build.sh`（构建前端 + Maven 打包后端）、`scripts/coze-deploy-run.sh`（启动 JAR，端口 5000）
- 根 `.coze` 的 `[deploy]` 调用上述脚本
- 部署需要完整的 Java + MySQL 环境；前端构建产物由 Spring Boot 作为静态资源服务
- 后端默认端口 8080，部署脚本通过 `-Dserver.port=5000` 覆盖

## 用户偏好与长期约束

- Node.js 项目必须使用 pnpm
- 前端项目无 lock 文件，首次安装依赖需生成 pnpm-lock.yaml

## 常见问题和预防

- 前端项目原使用 npm，需统一切换为 pnpm
- 后端 API 不可用时，前端页面可展示但数据接口会报错
- Vue 2 项目使用 @vue/cli-service 3.x（实际为 4.4.4），注意兼容性
- 部署环境需要 MySQL 数据库，需提前导入 `litemall-db/sql/` 下的 SQL 脚本
- 项目 JDK 版本为 1.8，部署使用 java-17 运行时应向下兼容
