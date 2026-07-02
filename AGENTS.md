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

- 当前沙箱环境仅有 Node.js 24，无 Java/Maven/MySQL
- 前端子项目（litemall-admin、litemall-vue）可独立安装依赖并启动开发服务器
- 后端服务需要 MySQL + JDK 环境，当前环境不可用
- 前端开发服务器默认端口需代理到后端 API（见各 .env.development 配置）

### 预览链路

- 项目被判定为 Web 预览型项目（存在 Vue 管理后台和移动端前端）
- 预览入口：litemall-admin（Vue 2 + Element UI 管理后台）
- 预览脚本：`scripts/coze-preview-build.sh`（安装依赖）、`scripts/coze-preview-run.sh`（启动 dev server）
- 根 `.coze` 的 `[dev]` 调用上述脚本，脚本内部 cd 到 `litemall-admin/` 执行
- 预览服务绑定 `0.0.0.0:5000`，后端 API 代理不可用（无 Java 环境），页面可展示但接口报错
- vue-cli-service 4.4.4 支持 `--host` 和 `--port` 参数透传

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
