# ---------- 第一阶段：构建前端 ----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && corepack prepare pnpm@latest --activate && pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

# ---------- 第二阶段：运行后端 + 托管前端静态文件 ----------
FROM node:20-alpine
WORKDIR /app
# 安装生产依赖
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && corepack prepare pnpm@latest --activate && pnpm install --prod --frozen-lockfile
# 复制必要源码
COPY --from=builder /app/dist ./dist
COPY server/ ./server/
COPY util/ ./util/
COPY module/ ./module/
COPY config.json ./
# 修改 server/index.js 使其托管前端静态文件（需要一行代码）
# 但我们已经将修改后的 index.js 放在下面，直接复制
COPY server-entry.js ./server/index.js
COPY config.json ./
# 暴露端口
ENV PORT=6522
EXPOSE 6522
CMD ["node", "server/index.js"]
