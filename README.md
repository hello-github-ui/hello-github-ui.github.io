# QiYue's Blog - 部署仓库

> **此仓库为自动构建的部署产物**，包含 Hugo 构建后的静态文件（HTML/CSS/JS/图片），不包含源码。

## 说明

| 仓库 | 可见性 | 用途 |
|------|--------|------|
| **hello-github-ui/blog-source** | 🔒 Private | 源码、Markdown 文章、主题配置 |
| **hello-github-ui/hello-github-ui.github.io**（本仓库） | 🌍 Public | CI 自动构建的静态站点产物 |

本仓库由 GitHub Actions 自动构建并推送，**请勿手动修改**。

所有内容更新请在[源码仓库](https://github.com/hello-github-ui/blog-source)中进行，推送后 CI 会自动同步到本仓库。

## 站点地址

| 角色 | URL |
|------|-----|
| 🟢 主站点 (Render) | https://hello-github-ui-github-io.onrender.com/ |
| 🟡 备份站点 (GitHub Pages) | https://hello-github-ui.github.io/ |

## 最近部署

由 GitHub Actions 自动触发，构建来源于源码仓库 `main` 分支。
