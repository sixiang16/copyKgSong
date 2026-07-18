FROM python:3.9-slim
WORKDIR /app

# 安装系统依赖（可能需用到的图像处理库等）
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制整个项目
COPY . .

# 启动 API 服务
CMD ["python", "api.py"]
