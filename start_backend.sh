#!/bin/bash
# 启动 deepwiki-open 后端 FastAPI 服务（本地+Docker通用）

# 默认端口和主机
PORT=${PORT:-8001}
HOST=${HOST:-0.0.0.0}

# 激活本地虚拟环境（开发用）
if [ -f "api/venv/bin/activate" ]; then
  source api/venv/bin/activate
fi

# 激活 Docker venv（生产用）
if [ -f "/opt/venv/bin/activate" ]; then
  source /opt/venv/bin/activate
fi

# 安装依赖（首次或依赖变更时需要）
if [ -f "api/requirements.txt" ]; then
  pip install --no-cache-dir -r api/requirements.txt
fi

# 读取 .env 文件
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

export SERVER_BASE_URL="http://localhost:$PORT"

# 启动服务（优先用 uvicorn，找不到再用 python3）
if command -v uvicorn >/dev/null 2>&1; then
  exec uvicorn api.api:app --host $HOST --port $PORT --reload
else
  exec PYTHONPATH=. python3 api/main.py
fi
