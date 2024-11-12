#!/bin/bash

# 设置日志目录的父目录
log_dir="/var/local"

# 设置保留天数(3天)
keep_days=2

# 遍历所有 game-log-* 目录
find "$log_dir" -maxdepth 1 -type d -name "game-log-*" -print0 | while IFS= read -r -d $'\0' game_log_dir; do
  # 遍历 debug, error, info, log_write, report, stat, system 子目录
  for subdir in debug error info log_write report stat system; do
    # 构建子目录的完整路径
    subdir_path="$game_log_dir/$subdir"

    # 检查子目录是否存在
    if [ -d "$subdir_path" ]; then
      # 删除三天前的文件
      find "$subdir_path" -type f -mtime +"$keep_days" -delete
    fi
  done
done

echo -e "\e[31m日志清理完成\e[0m" 
