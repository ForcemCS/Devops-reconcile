#!/bin/bash  

# 检查是否提供了参数  
if [ $# -eq 0 ]; then  
    echo "用法: $0 <游戏服编号1> <游戏服编号2> ..."  
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
