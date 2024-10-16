#!/bin/bash

# 检查是否提供了两个参数
if [ $# -ne 2 ]; then
  echo -e "\e[35m用法: $0 <起始数字> <结束数字>.\e[0m"
  exit 1
fi

start=$1
end=$2

# 检查起始数字和结束数字是否有效
if [[ ! "$start" =~ ^[0-9]+$ ]] || [[ ! "$end" =~ ^[0-9]+$ ]]; then
  echo "错误: 起始数字和结束数字必须是整数."
  exit 1
fi

# 循环生成 Service 资源
for i in $(seq -f "%02g" $start $end); do
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: extend-hdh5-100$i
  namespace: hdh5
spec:
  ports:
  - name: game-svc-5
    port: 10010
    protocol: TCP
    nodePort: 322$i
    targetPort: 10010
  selector:
    app.kubernetes.io/instance: game-100$i
    app.kubernetes.io/name: roh5-server
    game-svc: game-svc-100$i
  type: NodePort
EOF
done

echo -e "\e[35m已创建 Service 资源，范围从 extend-hdh5-100$start 到 extend-hdh5-100$end.\e[0m" 
