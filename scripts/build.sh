#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 切换到项目根目录
cd "$SCRIPT_DIR/.."

# 使用共享的环境脚本
source "$SCRIPT_DIR/activate_env.sh" || exit 1

# 清理旧的构建文件
echo "清理旧的构建文件..."
bash scripts/clean.sh

# 安装构建依赖
echo "安装构建依赖..."
if command -v uv &>/dev/null; then
    echo "使用 uv 安装依赖..."
    uv pip install build twine pytest
elif command -v python &>/dev/null; then
    echo "使用 python pip 安装依赖..."
    python -m pip install build twine pytest
else
    echo "使用 pip 安装依赖..."
    pip install build twine pytest
fi

# 先以开发模式安装当前包
echo "以开发模式安装当前包..."
if command -v uv &>/dev/null; then
    echo "使用 uv 以开发模式安装当前包..."
    uv pip install -e .
else
    echo "使用 pip 以开发模式安装当前包..."
    $VENV_PYTHON -m pip install -e .
fi

# 运行测试
echo "运行测试..."
$VENV_PYTHON -m pytest tests/

# 如果测试通过，继续构建包
if [ $? -eq 0 ]; then
    echo "测试通过，开始构建包..."
    $VENV_PYTHON -m build

    if [ $? -eq 0 ]; then
        echo "构建成功！"
        echo "构建文件位于 dist/ 目录"
    else
        echo "构建失败"
        exit 1
    fi
else
    echo "测试失败，构建已中止"
    exit 1
fi
