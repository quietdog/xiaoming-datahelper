#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 切换到项目根目录
cd "$SCRIPT_DIR/.."

# 使用共享的环境脚本
source "$SCRIPT_DIR/activate_env.sh" || exit 1

echo "开始上传包..."

# 检查 dist 目录是否存在
if [ ! -d "dist" ]; then
    echo "错误: dist 目录不存在，请先运行构建脚本"
    exit 1
fi

# 检查是否有构建文件
WHL_COUNT=$(find dist -name "*.whl" | wc -l)
TAR_COUNT=$(find dist -name "*.tar.gz" | wc -l)

if [ "$WHL_COUNT" -eq 0 ] && [ "$TAR_COUNT" -eq 0 ]; then
    echo "错误: dist 目录中没有找到构建文件"
    exit 1
fi

# 上传到 PyPI
echo "上传到 PyPI..."
$VENV_PYTHON -m twine upload dist/*

if [ $? -eq 0 ]; then
    echo -e "\n上传成功！"
    echo "包已发布到 PyPI"
else
    echo -e "\n上传失败"
    exit 1
fi
