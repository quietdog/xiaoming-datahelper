#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 切换到项目根目录
cd "$SCRIPT_DIR/.."

# 检查虚拟环境是否存在
if [ ! -d ".venv" ]; then
    echo "警告: 未找到 .venv 虚拟环境，请使用uv venv --python 3.9创建"
    exit 1
fi

echo "虚拟环境路径: $(pwd)/.venv"

# 定义Python
export VENV_PYTHON="$(pwd)/.venv/bin/python"

# 检查可执行文件是否存在
if [ ! -f "$VENV_PYTHON" ]; then
    echo "错误: 虚拟环境中没有找到Python: $VENV_PYTHON"
    exit 1
fi
