#!/bin/bash  

# 检查是否提供了游戏服编号  
if [ $# -eq 0 ]; then  
    echo "用法: $0 <游戏服编号1> <游戏服编号2> ..."  
    exit 1  
fi  

# 遍历每个游戏服编号  
for GAME_SERVER_ID in "$@"; do  
    # 构建 Pod 名称前缀  
    POD_NAME="game-roh5-server-${GAME_SERVER_ID}-"  

    # 获取 Pod 的实际名称  
    ACTUAL_POD_NAME=$(kubectl get pods --no-headers | grep "${POD_NAME}" | awk '{print $1}')  

    # 检查是否找到了 Pod  
    if [ ! -z "$ACTUAL_POD_NAME" ]; then  
        echo "正在删除 Pod: $ACTUAL_POD_NAME"  
        kubectl delete pod "$ACTUAL_POD_NAME"  
    else  
        echo "未找到对应的 Pod: ${POD_NAME}，可能是游戏服编号错误或 Pod 不存在。"  
    fi  
done
