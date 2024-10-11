#!/bin/bash  

# 检查输入参数个数  
if [ "$#" -ne 2 ]; then  
    echo "用法: $0 <起始数字> <结束数字>"  
    exit 1  
fi  

# 获取输入的起始和结束数字  
START=$1  
END=$2  

# 验证输入是否为数字  
if ! [[ "$START" =~ ^[0-9]+$ ]] || ! [[ "$END" =~ ^[0-9]+$ ]]; then  
    echo "错误: 起始和结束数字必须是数字！"  
    exit 1  
fi  

# 生成从 START 到 END 的数字  
for (( i=START; i<=END; i++ )); do  
    echo -n "$i "  # 输出数字，不换行  
done  

echo  # 输出一个换行符
