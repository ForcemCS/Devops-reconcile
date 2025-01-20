## 命令说明
查找pod内部容器在节点的进程ID(roh5-server进程在物理节点上的进程id为39744)
```shell
root@debian:~# crictl  ps -a     |grep 10012 
90037e25de480       56b780ba008f1       2 minutes ago       Running             roh5-server                          0                   7c0a115ce8d3e       game-roh5-server-10012-57565c7867-nc77t
db1b4084ce546       87ff76f62d367       2 minutes ago       Exited              setsysctl                            0                   7c0a115ce8d3e       game-roh5-server-10012-57565c7867-nc77t
root@debian:~# ps -aux    |grep 7c0a115ce8d3e  
root       39576  0.0  0.0 722928 12064 ?        Sl   11:05   0:00 /var/lib/rancher/k3s/data/28f7e87eba734b7f7731dc900e2c84e0e98ce869f3dcf57f65dc7bbb80e12e56/bin/containerd-shim-runc-v2 -namespace k8s.io -id 7c0a115ce8d3ef19ef53d24ce360d2d0f1361cc575e1a0a70fe52b247e9ed76d -address /run/k3s/containerd/containerd.sock
root       40818  0.0  0.0   6332  2196 pts/1    S+   11:09   0:00 grep 7c0a115ce8d3e
root@debian:~#  crictl inspect   90037e25de480     | jq -r '.info.pid'
39744
```
分析内存泄露
```shell
指定检测间隔和执行时间（例如：每5秒检测一次，持续60秒）：
sudo memleak -p 39744 -t 5 60

只显示前10个最严重的内存泄漏:
sudo memleak -p 39744 --count 10

根据命令名称过滤, 并显示 top 5 泄漏:
sudo memleak -c skynet --count 5

只显示汇总信息:
sudo memleak -c skynet --combined-only
```
