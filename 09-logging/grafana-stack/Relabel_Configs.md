### 配置段说明

```
scrape_configs:
  # See also https://github.com/grafana/loki/blob/master/production/ksonnet/promtail/scrape_config.libsonnet for reference
  - job_name: kubernetes-pods
    pipeline_stages:
      - cri: {}
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
          - roh5server
    relabel_configs:
      - source_labels:
          - __meta_kubernetes_pod_controller_name
        regex: ([0-9a-z-.]+?)(-[0-9a-f]{8,10})?
        action: replace
        target_label: __tmp_controller_name
      - source_labels:
          - __meta_kubernetes_pod_label_app_kubernetes_io_name
          - __meta_kubernetes_pod_label_app
          - __tmp_controller_name
          - __meta_kubernetes_pod_name
        regex: ^;*([^;]+)(;.*)?$
        action: replace
        target_label: app
      - source_labels:
          - __meta_kubernetes_pod_label_app_kubernetes_io_instance
          - __meta_kubernetes_pod_label_instance
        regex: ^;*([^;]+)(;.*)?$
        action: replace
        target_label: instance
      - source_labels:
          - __meta_kubernetes_pod_label_app_kubernetes_io_component
          - __meta_kubernetes_pod_label_component
        regex: ^;*([^;]+)(;.*)?$
        action: replace
        target_label: component
      - action: keep
        regex: game-svc
        source_labels:
        - __meta_kubernetes_pod_label_app
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: node_name
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - namespace
        - app
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: pod
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container
      - action: replace
        replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_uid
        - __meta_kubernetes_pod_container_name
        target_label: __path__
      - action: replace
        regex: true/(.*)
        replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_annotationpresent_kubernetes_io_config_hash
        - __meta_kubernetes_pod_annotation_kubernetes_io_config_hash
        - __meta_kubernetes_pod_container_name
        target_label: __path__

```

这段 Promtail 配置代码定义了一个名为 `kubernetes-pods` 的任务，用于从 Kubernetes 集群中的 Pod 中收集日志。下面逐行解释代码含义：

**全局配置**

```yaml
scrape_configs:
  # ... 其他 scrape 配置 ...
  - job_name: kubernetes-pods  # 定义该任务的名称为 "kubernetes-pods"
```

**流水线阶段**

```yaml
    pipeline_stages:
      - cri: {}  # 使用 CRI (Container Runtime Interface) 方式收集日志
```

**服务发现配置**

```yaml
    kubernetes_sd_configs:
      - role: pod  # 指定从 Kubernetes 的 Pod 中发现目标
        namespaces:  # 指定要收集日志的命名空间
          names:
            - roh5server  # 只收集 "roh5server" 命名空间下的 Pod 日志
```

**标签重写配置**

```yaml
    relabel_configs:
      # ... 其他 relabel_configs ...
```

`relabel_configs` 部分包含一系列规则，用于修改从 Kubernetes 收集到的元数据标签。下面逐条解释：

1. **提取控制器名称**:

   ```yaml
     - source_labels:
         - __meta_kubernetes_pod_controller_name  # 从该标签提取信息
       regex: ([0-9a-z-.]+?)(-[0-9a-f]{8,10})?  # 使用正则表达式提取控制器名称
       action: replace  # 将提取的结果替换到目标标签
       target_label: __tmp_controller_name  # 将结果存储到 "__tmp_controller_name" 标签
   ```

   这部分配置使用正则表达式从 `__meta_kubernetes_pod_controller_name` 标签中提取控制器名称，并将其存储到 `__tmp_controller_name` 标签中。

2. **提取应用名称**:

   ```yaml
     - source_labels:
         - __meta_kubernetes_pod_label_app_kubernetes_io_name
         - __meta_kubernetes_pod_label_app
         - __tmp_controller_name
         - __meta_kubernetes_pod_name
       regex: ^;*([^;]+)(;.*)?$  # 使用正则表达式提取应用名称
       action: replace
       target_label: app  # 将结果存储到 "app" 标签
   ```

   这部分配置尝试从多个标签中提取应用名称，并将结果存储到 `app` 标签中。

3. **提取实例名称**:

   ```yaml
     - source_labels:
         - __meta_kubernetes_pod_label_app_kubernetes_io_instance
         - __meta_kubernetes_pod_label_instance
       regex: ^;*([^;]+)(;.*)?$  # 使用正则表达式提取实例名称
       action: replace
       target_label: instance  # 将结果存储到 "instance" 标签
   ```

   这部分配置尝试从多个标签中提取实例名称，并将结果存储到 `instance` 标签中。

4. **提取组件名称**:

   ```yaml
     - source_labels:
         - __meta_kubernetes_pod_label_app_kubernetes_io_component
         - __meta_kubernetes_pod_label_component
       regex: ^;*([^;]+)(;.*)?$  # 使用正则表达式提取组件名称
       action: replace
       target_label: component  # 将结果存储到 "component" 标签
   ```

   这部分配置尝试从多个标签中提取组件名称，并将结果存储到 `component` 标签中。

5. **保留特定应用**:

   ```yaml
     - action: keep  # 保留符合条件的日志
       regex: game-svc  # 只保留 "app" 标签值为 "game-svc" 的日志
       source_labels:
         - __meta_kubernetes_pod_label_app
   ```

   这部分配置只保留 `__meta_kubernetes_pod_label_app` 标签值为 "game-svc" 的日志。

6. **重命名节点名称标签**:

   ```yaml
     - action: replace
       source_labels:
         - __meta_kubernetes_pod_node_name
       target_label: node_name  # 将 "__meta_kubernetes_pod_node_name" 重命名为 "node_name"
   ```

   这部分配置将 `__meta_kubernetes_pod_node_name` 标签重命名为 `node_name`。

7. **重命名命名空间标签**:

   ```yaml
     - action: replace
       source_labels:
         - __meta_kubernetes_namespace
       target_label: namespace  # 将 "__meta_kubernetes_namespace" 重命名为 "namespace"
   ```

   这部分配置将 `__meta_kubernetes_namespace` 标签重命名为 `namespace`。

8. **组合命名空间和应用名称**:

   ```yaml
     - action: replace
       replacement: $1  # 使用第一个捕获组作为替换值
       separator: /  # 使用 "/" 分隔符
       source_labels:
         - namespace
         - app
       target_label: job  # 将组合后的结果存储到 "job" 标签
   ```

   这部分配置将 `namespace` 和 `app` 标签的值使用 "/" 分隔符组合起来，并将结果存储到 `job` 标签中。

9. **重命名 Pod 名称标签**:

   ```yaml
     - action: replace
       source_labels:
         - __meta_kubernetes_pod_name
       target_label: pod  # 将 "__meta_kubernetes_pod_name" 重命名为 "pod"
   ```

   这部分配置将 `__meta_kubernetes_pod_name` 标签重命名为 `pod`。

10. **重命名容器名称标签**:

    ```yaml
      - action: replace
        source_labels:
          - __meta_kubernetes_pod_container_name
        target_label: container  # 将 "__meta_kubernetes_pod_container_name" 重命名为 "container"
    ```

    这部分配置将 `__meta_kubernetes_pod_container_name` 标签重命名为 `container`。

11. **设置日志路径**:

    ```yaml
      - action: replace
        replacement: /var/log/pods/*$1/*.log  # 使用 Pod UID 和容器名称构建日志路径
        separator: /
        source_labels:
          - __meta_kubernetes_pod_uid
          - __meta_kubernetes_pod_container_name
        target_label: __path__  # 将构建的日志路径存储到 "__path__" 标签
    ```

    这部分配置使用 Pod UID 和容器名称构建日志路径，并将结果存储到 `__path__` 标签中。

12. **处理特殊情况下的日志路径**:

    ```yaml
      - action: replace
        regex: true/(.*)  # 匹配包含 "true/" 的路径
        replacement: /var/log/pods/*$1/*.log  # 使用匹配到的内容构建日志路径
        separator: /
        source_labels:
          - __meta_kubernetes_pod_annotationpresent_kubernetes_io_config_hash
          - __meta_kubernetes_pod_annotation_kubernetes_io_config_hash
          - __meta_kubernetes_pod_container_name
        target_label: __path__  # 将构建的日志路径存储到 "__path__" 标签
    ```

    这部分配置处理特殊情况下的日志路径，例如当路径中包含 "true/" 时，使用匹配到的内容构建日志路径，并将结果存储到 `__path__` 标签中。

总而言之，这段 Promtail 配置定义了一个名为 "kubernetes-pods" 的任务，用于从 Kubernetes 集群中名为 "roh5server" 的命名空间下的 Pod 中收集日志。它使用 CRI 方式收集日志，并通过一系列标签重写规则对收集到的元数据进行处理，最终将日志发送到 Loki 进行存储和分析。