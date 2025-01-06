#!/bin/bash

#此脚本实现了查找逐级当前目录下包含xxx的文件，然后替换为xxxx

#!/bin/bash

# 获取用户输入的字符串
old_string="$1"

# 检查是否提供了输入字符串
if [ -z "$old_string" ]; then
  echo "Usage: $0 <string_to_replace>"
  exit 1
fi

new_string="xxxxxxxxxxxx"

# 使用grep查找包含输入字符串的文件，并使用sed替换字符串
grep -r -l "$old_string" ./* | while read -r file; do
  if [ -f "$file" ]; then  # 确保是常规文件，避免处理目录
    sed -i "s/$old_string/$new_string/g" "$file"
    echo "Replaced '$old_string' with '$new_string' in $file"
  fi
done
