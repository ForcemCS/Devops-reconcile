#!/bin/bash

#关联数组可以使用字符串作为键，而不是像普通数组那样只能使用数字。这将用于存储不同类别的数据。
declare -A categories

# 循环开始，每次读取一行
while IFS=/ read -r -a parts; do   
  case "${parts[1]}" in            
    "角色")
      categories["角色"]+="${parts[2]}\n"
      ;;
    "装备")
      key="${parts[1]}/${parts[2]}"
      categories["$key"]+="${parts[4]}\n"
      ;;
    *) # Catch other categories like CTO/Weapon
      key="${parts[1]}/${parts[2]}"
      categories["$key"]+="${parts[4]}\n"
      ;;
  esac
done < <(find . -name "1.txt" -print0 | xargs -0 grep "NewAvatars" | cut -d '/' -f 2- )   #从中提取包含 "NewAvatars" 的行



for category in "${!categories[@]}"; do
  echo "$category"
  echo -e "${categories[$category]}"
done
