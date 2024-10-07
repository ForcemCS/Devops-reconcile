#!/bin/bash

read -p "请输入游戏服SID: " pod

pod_name=$(kubectl -n hdh5  get pods --no-headers  | grep "game-roh5-server-${pod}" | awk '{print $1}')


if [[ -z "$pod_name" ]]; then
  echo "游戏服【SID=${pod}】没有发现"
  exit 1
fi

#read -p "请输入要查看的日志行数或者某个时间段开始的日志【例如:2024-10-07T10:03:15Z  or 100】: " para
read -r -e -p $'\e[33m请输入要查看的日志行数或者某个时间段开始的日志【例如:2024-10-07T10:03:15Z or 100】:\e[0m ' para
echo "【注意时间信息应该减少8小时】"


if [[ "$para" =~ ^[0-9]+$ ]]; then
  kubectl -n hdh5 logs --tail="$para" "$pod_name" -f
else
  kubectl -n hdh5 logs --since-time="$para" "$pod_name" -f
fi
