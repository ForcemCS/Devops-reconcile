#!/bin/bash  

# 检查是否提供了参数  
if [ $# -eq 0 ]; then  
    echo -e "\033[31m用法: $0 <游戏服编号1> <游戏服编号2> ...\033[0m"
    exit 1  
fi  

# 初始化参数处理  
game_server_ids=()  

# 检查参数并处理增量逻辑  
if [ $# -eq 3 ] && [ "$3" -eq 1 ]; then  
    start="$1"  
    end="$2"  
    for ((i=start; i<=end; i++)); do  
        game_server_ids+=("$i")  
    done  
else  
    for arg in "$@"; do  
        if [[ "$arg" =~ ^[0-9]+$ ]] && [ "$arg" -gt 0 ]; then  
            game_server_ids+=("$arg")  
        else  
            echo "Error: 参数必须是正整数."  
            exit 1  
        fi  
    done  
fi  

# 打印游戏服务器编号  
echo -e "\033[31m游戏服编号: ${game_server_ids[*]}\033[0m" 

# 遍历每个游戏服编号，进行 Pod 删除操作  
for GAME_SERVER_ID in "${game_server_ids[@]}"; do  
    # 构建 Pod 名称前缀  
    POD_NAME="game-roh5-server-${GAME_SERVER_ID}-"  

    # 获取 Pod 的实际名称  
    ACTUAL_POD_NAME=$(kubectl get pods --no-headers | grep "^$POD_NAME" | awk '{print $1}')  

    # 检查是否找到了 Pod  
    if [ ! -z "$ACTUAL_POD_NAME" ]; then  
        echo "正在删除 Pod: $ACTUAL_POD_NAME"  
        kubectl delete pod "$ACTUAL_POD_NAME"  
    else  
        echo "未找到对应的 Pod: $POD_NAME，可能是游戏服编号错误或 Pod 不存在。"  
    fi  
done
