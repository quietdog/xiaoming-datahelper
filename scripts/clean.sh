#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 切换到项目根目录
cd "$SCRIPT_DIR/.."

# 使用共享的环境脚本
source "$SCRIPT_DIR/activate_env.sh" || exit 1

echo "开始清理 Python 缓存文件..."

# 要清理的文件和目录模式
PATTERNS=(
    "__pycache__"
    "*.pyc"
    "*.pyo"
    "*.pyd"
    ".pytest_cache"
    ".coverage"
    "htmlcov"
    "*.egg-info"
    "build"
    "dist"
    ".eggs"
    ".tox"
    "venv"
    ".env"
    ".mypy_cache"
    ".ruff_cache"
    ".hypothesis"
)

# 保存已清理的文件列表
CLEANED_FILES=()

# 清理所有模式
for PATTERN in "${PATTERNS[@]}"; do
    while IFS= read -r -d '' FILE; do
        # 忽略.venv目录及其子目录
        if [[ "$FILE" != *".venv"* ]]; then
            if [ -f "$FILE" ]; then
                rm "$FILE"
                echo "已清理: $FILE"
                CLEANED_FILES+=("$FILE")
            elif [ -d "$FILE" ]; then
                rm -rf "$FILE"
                echo "已清理: $FILE"
                CLEANED_FILES+=("$FILE")
            fi
        fi
    done < <(find . -name "$PATTERN" -print0)
done

# 显示清理结果
if [ ${#CLEANED_FILES[@]} -gt 0 ]; then
    echo -e "\n清理完成！已清理以下文件/目录："
    for ITEM in "${CLEANED_FILES[@]}"; do
        echo "- $ITEM"
    done
else
    echo -e "\n没有找到需要清理的文件。"
fi
