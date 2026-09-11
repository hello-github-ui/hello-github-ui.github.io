#!/usr/bin/env bash

set -Eeuo pipefail

# 可通过 Render 环境变量覆盖
HUGO_VERSION="${HUGO_VERSION:-0.165.0}"
DART_SASS_VERSION="${DART_SASS_VERSION:-1.102.0}"
HUGO_BASEURL="${HUGO_BASEURL:-https://hello-github-ui-github-io.onrender.com/}"

TOOLS_DIR="${HOME}/.local"
HUGO_DIR="${TOOLS_DIR}/hugo"
SASS_DIR="${TOOLS_DIR}/dart-sass"

mkdir -p "${TOOLS_DIR}" "${HUGO_DIR}" "${SASS_DIR}"

echo "Installing Hugo Extended ${HUGO_VERSION}..."

curl -fsSL \
  --retry 3 \
  -o /tmp/hugo.tar.gz \
  "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"

tar -xzf /tmp/hugo.tar.gz -C "${HUGO_DIR}"

echo "Installing Dart Sass ${DART_SASS_VERSION}..."

curl -fsSL \
  --retry 3 \
  -o /tmp/dart-sass.tar.gz \
  "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"

tar -xzf /tmp/dart-sass.tar.gz -C "${SASS_DIR}" --strip-components=1

export PATH="${HUGO_DIR}:${SASS_DIR}:${PATH}"

echo "Tool versions:"
hugo version
sass --version || true

echo "Build configuration:"
echo "HUGO_BASEURL=${HUGO_BASEURL}"
echo "TZ=${TZ:-}"

# 确保输出目录不存在旧文件
rm -rf public

hugo \
  --gc \
  --minify \
  --baseURL "${HUGO_BASEURL}" \
  --cacheDir "${HOME}/.cache/hugo"

test -f public/index.html

echo "Build completed successfully."
echo "Published directory: public"
