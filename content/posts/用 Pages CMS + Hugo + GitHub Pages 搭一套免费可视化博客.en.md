---
title: "Build a Free Visual Blog with Pages CMS, Hugo, and GitHub Pages"
date: 2026-09-09
draft: false
description: "A free alternative to WordPress: static sites, automated deployment via GitHub Actions, and a visual backend using Pages CMS. Includes complete steps for the offline installation of Hugo Extended on Windows."
tags:
  - Pages CMS
  - Hugo
  - GitHub Pages
  - GitHub
  - 笔记
  - WordPress
  - CMS
  - 博客
categories:
  - 教程
---
## 1. 前置准备

需要：

1. [GitHub 账号](https://github.com/signup)
2. 本机 [Git for Windows](https://git-scm.com/download/win)
3. 本机 Hugo Extended（下文离线安装）

建议先装 Git，再装 Hugo。两者都用安装包 / zip，不走包管理器。

### 1.1 离线安装 Git

1. 打开 [https://git-scm.com/download/win](https://git-scm.com/download/win)
2. 下载 **64-bit Git for Windows Setup**（.exe）
3. 双击安装，选项保持默认
4. 关键一项选 **Git from the command line and also from 3rd-party software**
5. 装完后**新开** PowerShell，执行：

PowerShell

```
git --version
```

应输出类似 git version [2.x.x.windows](http://2.x.x.windows).x。

第一次使用 Git，再执行一次（只做一次）：

PowerShell

```
git config --global user.name "你的名字"
git config --global user.email "你的邮箱@example.com"
```

### 1.2 离线安装 Hugo Extended

不要用：

PowerShell

```
winget install Hugo.Hugo.Extended
```

按下面做。

#### 下载正确的压缩包

打开官方发布页：

[https://github.com/gohugoio/hugo/releases/latest](https://github.com/gohugoio/hugo/releases/latest)

当前版本以 **v0.165.0** 为例。滚到 **Assets**，只下载这一份：


| 电脑类型 | 文件名 |
| ----------------------- | ------------------------------------------------------------------- |
| 普通 64 位 Windows（绝大多数） | hugo_extended_0.165.0_[windows-amd64.zip](http://windows-amd64.zip) |
| ARM 电脑（Surface Pro X 等） | hugo_extended_0.165.0_[windows-arm64.zip](http://windows-arm64.zip) |


64 位直链：

[https://github.com/gohugoio/hugo/releases/download/v0.165.0/hugo_extended_0.165.0_windows-amd64.zip](https://github.com/gohugoio/hugo/releases/download/v0.165.0/hugo_extended_0.165.0_windows-amd64.zip)

不要下载：

- hugo_0.165.0_[windows-amd64.zip](http://windows-amd64.zip)（没有 Extended，主题容易编不过）
- Source code (zip) / Source code (tar.gz)（源码，不是安装包）
- .deb / .tar.gz（Linux 包）

安装包大约 20MB。可以先下载再拷到离线电脑。

#### 解压到固定目录

建议放到不含空格、不会被清理的目录，不要留在「下载」里。

1. 在 C:\ 下新建 C:\Hugo\bin
2. 右键 zip → **全部提取**
3. 把解压出来的 hugo.exe 复制到 C:\Hugo\bin\

解压后通常有：

text

```
hugo.exe          ← 只要这一个
LICENSE
README.md
```

最后应是：

text

```
C:\Hugo\bin\hugo.exe
```

#### 把目录加入 PATH（图形界面）

1. 按 Win 键，搜索：**编辑系统环境变量**
2. 点 **环境变量**
3. 上面「用户变量」里选中 **Path** → **编辑**
4. **新建**，填：

text

```
C:\Hugo\bin
```

5. 一路确定保存
6. **关掉所有已经打开的 PowerShell / CMD / Windows Terminal**，再新开一个

#### 验证

新开 PowerShell：

PowerShell

```
hugo version
```

成功时应类似：

text

```
hugo v0.165.0+extended windows/amd64 ...
```

必须看到 +extended。如果提示「无法将 hugo 项识别为 cmdlet」：

- PATH 没加对，或旧终端没关
- hugo.exe 不在 C:\Hugo\bin
- 下载了错的 zip

可再确认：

PowerShell

```
Get-Command hugo | Format-List
Test-Path C:\Hugo\bin\hugo.exe
```

以后升级 Hugo：再下一个新版本 zip，用新的 hugo.exe 覆盖 C:\Hugo\bin\hugo.exe，不用改 PATH。本地版本尽量和后面 workflow 里的 HUGO_VERSION 一致。

## 2. 创建 GitHub 仓库

1. 打开 [https://github.com/new](https://github.com/new)
2. 仓库名必须是：[你的用户名.github.io](http://你的用户名.github.io)  
例如用户名是 alice，仓库就叫 [alice.github.io](http://alice.github.io)
3. 选 **Public**
4. **不要**勾选 Add a README
5. 点 Create repository

记下仓库地址，例如：

text

```
https://github.com/alice/alice.github.io.git
```

用户站最终网址：

text

```
https://alice.github.io
```

如果用项目站（仓库名任意），网址会变成 [https://用户名.github.io/仓库名/，baseURL](https://用户名.github.io/仓库名/，baseURL) 也要带上仓库名。个人博客建议用用户站。

## 3. 本地初始化 Hugo 站点

把下面的 alice 全部换成你的 GitHub 用户名。在 **PowerShell** 里执行：

PowerShell

```
cd $HOME
git clone https://github.com/alice/alice.github.io.git
cd alice.github.io

# 目录已有 .git，必须加 --force
hugo new site . --force --format toml
```

加上主题。这里用 [PaperMod](https://github.com/adityatelange/hugo-PaperMod)，以 git submodule 方式添加，这样 GitHub Actions 才能拉到主题：

PowerShell

```
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive
```

建图片目录、文章目录：

PowerShell

```
New-Item -ItemType Directory -Force -Path static\images, content\posts
```

在仓库根目录新建 .gitignore：

gitignore

```
/public/
/resources/_gen/
.hugo_build.lock
```

不要把 public/ 提交进仓库。Hugo 每次构建都会重新生成它。

## 4. 写 Hugo 配置

覆盖仓库根目录的 hugo.toml（把 alice、标题、作者改成你的）：

toml

```
baseURL = 'https://alice.github.io/'
languageCode = 'zh-cn'
defaultContentLanguage = 'zh-cn'
title = '我的博客'
theme = 'PaperMod'
hasCJKLanguage = true
enableRobotsTXT = true
enableGitInfo = true
pagination.pagerSize = 8

[caches.images]
  dir = ':cacheDir/images'

[params]
  env = 'production'
  description = '用 Hugo + Pages CMS 搭建的个人博客'
  author = 'Alice'
  defaultTheme = 'auto'
  ShowReadingTime = true
  ShowShareButtons = false
  ShowPostNavLinks = true
  ShowBreadCrumbs = true
  ShowCodeCopyButtons = true
  ShowRssButtonInSectionTermList = true
  ShowFullTextinRSS = false
  disableThemeToggle = false
  DateFormat = '2006-01-02'

  [params.homeInfoParams]
    Title = '你好，这里是 Alice'
    Content = '技术随笔 / 笔记 / 个人博客'

  [[params.socialIcons]]
    name = 'github'
    url = 'https://github.com/alice'

[menu]
  [[menu.main]]
    identifier = 'posts'
    name = '文章'
    url = '/posts/'
    weight = 10
  [[menu.main]]
    identifier = 'tags'
    name = '标签'
    url = '/tags/'
    weight = 20
  [[menu.main]]
    identifier = 'archives'
    name = '归档'
    url = '/archives/'
    weight = 30
  [[menu.main]]
    identifier = 'search'
    name = '搜索'
    url = '/search/'
    weight = 40

[outputs]
  home = ['HTML', 'RSS', 'JSON']
```

PaperMod 的搜索页和归档页需要两个特殊文件。

content/[search.md](http://search.md)：

Markdown

```
---
title: "搜索"
layout: "search"
summary: "search"
placeholder: "输入关键词"
---
```

content/[archives.md](http://archives.md)：

Markdown

```
---
title: "归档"
layout: "archives"
summary: "archives"
---
```

再写一篇测试文章 content/posts/[hello-world.md](http://hello-world.md)：

Markdown

```
---
title: "你好，世界"
date: 2026-09-09T12:00:00+08:00
draft: false
description: "这是第一篇文章，用来验证站点能编译、能发布。"
tags:
  - 随笔
categories:
  - 博客
---

这是用 **Hugo + Pages CMS + GitHub Pages** 发布的第一篇文章。

如果本地预览和线上都能看到这段文字，说明搭建成功。
```

本地先跑起来确认没问题：

PowerShell

```
hugo server -D
```

终端里会出现类似 [http://localhost:1313/。浏览器打开，应能看到首页和《你好，世界》。能打开后再](http://localhost:1313/。浏览器打开，应能看到首页和《你好，世界》。能打开后再) Ctrl+C 停掉。

## 5. 配置 GitHub Actions 自动部署

创建目录：

PowerShell

```
New-Item -ItemType Directory -Force -Path .github\workflows
```

新建 .github/workflows/hugo.yaml。时区用上海，Hugo 用 Extended，版本和本机保持一致：

YAML

```
name: Build and deploy

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      DART_SASS_VERSION: 1.102.0
      HUGO_VERSION: 0.165.0
      TZ: Asia/Shanghai
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5

      - name: Create a local tools directory
        run: mkdir -p "${HOME}/.local"

      - name: Install Dart Sass
        run: |
          curl -sfL --output-dir "${{ runner.temp }}" -O "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
          tar -C "${HOME}/.local" -xf "${{ runner.temp }}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
          echo "${HOME}/.local/dart-sass" >> "$GITHUB_PATH"

      - name: Install Hugo
        run: |
          curl -sfL --output-dir "${{ runner.temp }}" -O "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
          mkdir -p "${HOME}/.local/hugo"
          tar -C "${HOME}/.local/hugo" -xf "${{ runner.temp }}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
          echo "${HOME}/.local/hugo" >> "$GITHUB_PATH"

      - name: Log tool versions
        run: |
          hugo version
          command -v sass && sass --version || true

      - name: Build
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/" \
            --cacheDir "${{ runner.temp }}/.cache/hugo"

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

说明：

- 这份 workflow 跑在 GitHub 的 Linux 机器上，和本机是不是 Windows 无关
- 本机 hugo.exe 只用于本地预览
- 也可以在仓库网页 Settings → Pages 里选 GitHub Actions，再套用官方 Hugo 模板；直接提交上面这份更稳，能保证 Extended、时区和子模块都开对

## 6. 配置 Pages CMS 可视化后台

在仓库根目录新建 **.pages.yml**（不是 .pages.config.yml）：

YAML

```
media:
  input: static/images
  output: /images
  rename: safe
  categories: [image]

content:
  - name: posts
    label: 博客文章
    type: collection
    path: content/posts
    format: yaml-frontmatter
    filename:
      template: "{year}-{month}-{day}-{title}.md"
      field: create
    view:
      fields: [title, date, draft]
      primary: title
      sort: [date, title]
      default:
        sort: date
        order: desc
    fields:
      - name: title
        label: 文章标题
        type: string
        required: true
      - name: date
        label: 发布日期
        type: date
      - name: draft
        label: 草稿
        type: boolean
      - name: description
        label: 文章摘要
        type: text
      - name: tags
        label: 标签
        type: string
        list: true
      - name: categories
        label: 分类
        type: string
        list: true
      - name: body
        label: 正文
        type: rich-text
```

这样后台会：

- 把新文章存成 content/posts/[2026-09-09-文章标题.md](http://2026-09-09-文章标题.md)
- 图片存到 static/images/，正文里引用 /images/xxx.jpg
- body 写在 YAML front matter 下面，正好是 Hugo 要的格式

Hugo 会把 static/ 原样拷到站点根目录，所以 static/images/foo.jpg 线上地址就是 /images/foo.jpg。不要用 assets/images，除非另外做 Hugo Pipes 处理。

## 7. 第一次推上去，打开 GitHub Pages

PowerShell

```
cd $HOME\alice.github.io
git add .
git status
git commit -m "Initialize Hugo site with Pages CMS"
git branch -M main
git push -u origin main
```

如果 git push 要登录：用浏览器弹出的 GitHub 登录，或在 GitHub → Settings → Developer settings → Personal access tokens 生成 token，密码处粘贴 token。

然后在 GitHub 网页上：

1. 打开仓库 → **Settings → Pages**
2. **Build and deployment → Source** 选 **GitHub Actions**（改完立刻生效，没有 Save 按钮）
3. 打开仓库的 **Actions** 标签，等 “Build and deploy” 变成绿色
4. 若第一次部署弹出 **github-pages environment** 等待审批，点 **Review deployments → Deploy**

大约 1–2 分钟后访问：

text

```
https://alice.github.io
```

能看到首页和测试文章，这一步才算发布成功。

常见失败：

- Actions 报 submodule 拉不下来：确认主题是 git submodule add 加进去的，且 workflow 里有 submodules: recursive
- 页面 CSS 全无 / 链接 404：baseURL 或仓库名不是 [用户名.github.io](http://用户名.github.io)
- 构建失败缺 hugo：检查 HUGO_VERSION 是否写对、是否下载的 hugo_extended_...

## 8. 用网页后台发文

前期配置完成后，日常可以不再碰命令行。

1. 打开 [https://app.pagescms.org](https://app.pagescms.org)
2. **Sign in with GitHub**
3. 按提示 **Install GitHub App**，授权刚才那个仓库（只授权这一个即可）
4. 回到 Pages CMS，点开该仓库
5. 若提示没有配置文件，确认根目录已经有 .pages.yml 并已推到 main

日常发文：

1. 左侧选 **博客文章**
2. 点 **Add an entry**
3. 填标题、日期、摘要、标签
4. 正文用可视化编辑器，或直接写 Markdown
5. 图片拖进编辑器，会自动上传到 static/images/
6. 点保存 → Pages CMS 向仓库提交一次 commit → 自动触发 Actions → 约 1–2 分钟网站更新

草稿：把 **草稿** 打开保存。Hugo 默认不发布 draft: true 的文章，适合先写后发。

## 9. 可选：自定义域名

1. 在域名 DNS 加一条 CNAME：[blog.example.com](http://blog.example.com) → [alice.github.io](http://alice.github.io)
2. 仓库 **Settings → Pages → Custom domain** 填 [blog.example.com](http://blog.example.com)
3. 勾选 Enforce HTTPS
4. 把 hugo.toml 里的 baseURL 改成 [https://blog.example.com/](https://blog.example.com/)
5. 再 push 一次

## 10. 之后维护


| 要做的事 | 在哪做 |
| ------------- | --------------------------------------------------- |
| 写新文章、改旧文、传图 | [app.pagescms.org](http://app.pagescms.org) |
| 改网站标题、菜单、主题参数 | 本地改 hugo.toml 后 git push，或把该文件也配进 .pages.yml 当单文件编辑 |
| 换主题 / 升级 Hugo | 本地改 submodule，或改 workflow 里的 HUGO_VERSION，再 push |
| 看发布是否成功 | GitHub 仓库 **Actions** |


升级主题：

PowerShell

```
cd $HOME\alice.github.io\themes\PaperMod
git pull
cd ..\..
git add themes/PaperMod
git commit -m "Update PaperMod"
git push
```

升级本机 Hugo：下载新的 hugo_extended_*_[windows-amd64.zip](http://windows-amd64.zip)，覆盖 C:\Hugo\bin\hugo.exe，同时改 workflow 里的 HUGO_VERSION。

## 最小验收清单

1. hugo version 能跑，且带 +extended
2. git --version 能跑
3. hugo server -D 本地能看到测试文章
4. git push 后 Actions 全绿
5. [https://你的用户名.github.io](https://你的用户名.github.io) 能打开
6. Pages CMS 能登录、能看到「博客文章」
7. 后台新建一篇、保存，1–2 分钟后线上出现

做完这 7 步，就可以当 WordPress 的免费替代来用：静态访问、自动部署、网页后台发文，个人博客长期零成本。

## 附录：Windows 常见问题

**hugo version 没有 +extended**  
  
下错包了。删掉 hugo.exe，改下 hugo_extended_..._[windows-amd64.zip](http://windows-amd64.zip)。

**解压后有一堆 .md 没有 hugo.exe**  
  
下的是 Source code，不是 Assets 里的二进制 zip。

**PowerShell 执行策略报错**  
  
hugo.exe 是独立程序，一般不触发。若 git 脚本被拦：

PowerShell

```
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

**杀毒软件拦截 hugo.exe**  
  
放行即可，这是官方发布的单文件程序。

**旧终端里仍然找不到 hugo**  
  
改 PATH 后必须新开 PowerShell，已经打开的窗口不会自动刷新环境变量。