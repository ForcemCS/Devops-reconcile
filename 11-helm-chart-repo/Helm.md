# Helm Overview

**Note:** 本指南介绍的是Helm 3

+ 官方文档： https: [//helm.sh/docs/](https://helm.sh/docs/)
+ Stack Overflow: https://stackoverflow.com/questions/tagged/kubernetes-helm

Helm 通过引入 **Helm chart**的概念、在 Kubernetes 上运行的应用程序的可重用且可配置的部署单元以及用于管理这些应用程序生命周期的命令行界面来减轻这种复杂性

**Helm chart** 包含用于描述在 Kubernetes 上运行的应用程序的文件,还可以指定应用程序运行所需的依赖项.Helm 与这些其他工具之间的主要区别在于安装的目标环境。Helm 不是直接在计算机上安装应用程序，而是将应用程序安装到 Kubernetes 集群中

### Helm Architecture

在Helm工作流中会发生一下过程：

+ Helm fetches chart package from remote chart repository (optional).
+ Helm 转换 chart 为 Kubernetes resource YAML
+ Helm 通过 HTTPS 将原始 YAML 内容发送到 Kubernetes API 服务器。
+ Kubernetes API 服务器处理所需资源（Pod 等）的调度。

### Helm Terminology

+ Helm CLI/Helm 客户端

  Helm CLI（命令行界面）也称为 Helm 客户端，它本身就是一个工具，是一个特定于平台的二进制文件，安装在执行 Helm 操作的计算机或服务器上。

+ Chart

  Chart 是 Helm 特有的包类型，实际上只是一个简单的压缩 文件 ( **.tgz** )。chart包含定义要在 Kubernetes 上部署的应用程序的文件集合。可以从本地目录或远程*chart存储库*安装chart。

+ Chart Repository

  Chart  Repository是 Helm 客户端可访问的远程服务，其中包含先前发布的 Chart 版本的索引。 Repository对于与其他人共享预构建的chart特别有用，但它们不一定是必需的。[可以在Helm Hub](https://hub.helm.sh/)中找到Chart Repository及其Chart的集合。

+ Chart.yaml

  **Chart.yaml**是 Helm chart中的一个特殊文件，其中包含有关chart的元数据，包括其名称、版本和所需的chart依赖项。

+ Templates

  模板包含chart中的大部分文件。模板是包含内联模板的 YAML 文件，在安装时被渲染成 YAML 并应用到 Kubernetes。

+ Values/Values File/values.yaml

  Values是键值对，定义给定 Helm*版本*的配置。Values File是指包含这些值的集合的 YAML 文件。**每个chart在名为value.yaml**的特殊文件中定义默认值集。

+ Release

  发布是 Kubernetes 集群中chart安装的实例。版本可以升级、回滚（降级）或卸载。版本具有唯一的名称。基于单个 Helm chart，同一个 Kubernetes 集群中可以存在多个版本。

### Install Helm Cli

```shell
root@master01:~/helm-install# tar     xf  helm-v3.12.3-linux-amd64.tar.gz 
root@master01:~/helm-install# ls
helm-v3.12.3-linux-amd64.tar.gz  linux-amd64
root@master01:~/helm-install# mv  linux-amd64/helm   /usr/local/bin/helm  
root@master01:~/helm-install# helm version  
version.BuildInfo{Version:"v3.12.3", GitCommit:"3a31588ad33fe3b89af5a2a54ee1d25bfe6eaa5e", GitTreeState:"clean", GoVersion:"go1.20.7"}

```

#### Running Your First Application

```shell
#创建属于自己的chart(可以认为是创建了一个自定义的应用程序管理库)
root@master01:~/helm-install# helm create myapp  
Creating myapp
#通过上一步创建的chart来安装chart中所表述的应用程序，可以给这个应用程序起一个名字（demo）,专业的叫法是 a new Helm release
root@master01:~/helm-install# helm install  demo myapp
demo-myapp-59db46899d-kth8wroot@master01:~/helm-install# kubectl  get  pods  
NAME                              READY   STATUS    RESTARTS   AGE
demo-myapp-59db46899d-kth8w       1/1     Running   0          19m
#Delete a release
root@master01:~/helm-install# helm  delete  demo 

```

### Chart

#### Helm Chart 的组成部分

+ **Chart.yaml**是任何 Helm chart中的主要文件，并且应该始终存在。此文件描述有关chart的详细信息和元数据。

  ```yaml
  apiVersion: v2   #要使用的chart API 版本
  name: myapp      #chart的名称。
  description: A Helm chart for Kubernetes  #chart的简要秒速
  type: application   #chart的类型 （application or library）
  version: 0.1.0      #chart的版本
  appVersion: 1.16.0  #正在部署的应用程序的版本
  #以下是支持的其他字段
  home:
  URL to the project homepage.
  sources:
  List of URL(s) for the chart’s source code.
  keywords:
  List of terms used to locate this chart.
  maintainers:
  A list of name/email combinations of chart maintainers.
  icon:
  A URL to an image representing this chart.
  kubeVersion:
  A SemVer constraint specifying the version of Kubernetes required.
  dependencies:
  A list of dependency charts required by this chart (you can find more information about dependencies later in this chapter, see: "Dependencies").
  ```

+ **value.yaml**表示 Helm chart的所有默认设置。也就是说，如果您要在没有任何自定义的情况下安装此chart，安装的应用程序会是什么样子

  ```yaml
  Here is an example of a basic values.yaml:
  
  replicaCount: 1
  image:
    repository: nginx
    pullPolicy: IfNotPresent
    tag: ""
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  serviceAccount:
    create: true
    annotations: {}
    name: ""
  podAnnotations: {}
  podSecurityContext: {}
  securityContext: {}
  service:
    type: ClusterIP
    port: 80
  ingress:
    enabled: false
    annotations: {}
    hosts:
      - host: chart-example.local
        paths: []
    tls: []
  resources: {}
  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 100
    targetCPUUtilizationPercentage: 80
  nodeSelector: {}
  tolerations: []
  affinity: {}
  ```

+ **templates**，每个 Helm chart的核心是**templates/**目录。**该目录包含以.yaml**（或**.yml** ）为后缀的文件集合。

  示例性的结构如下

  **templates/
  ├── NOTES.txt
  ├── _helpers.tpl
  ├── deployment.yaml
  ├── hpa.yaml
  ├── ingress.yaml
  ├── service.yaml
  ├── serviceaccount.yaml
  └── tests
    └── test-connection.yaml**

  例如**deployment.yaml**会将**value.yaml**中的值或者**Chart.yaml**中的值传递进来。也就是说可以动态的生成yaml文件

  **image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"**转化为**image: "nginx:1.16.0"**

  可以根据自己的实验进行验证

  **NOTE:** 此模板还支持条件语句和函数

+ **charts**目录来保存当前chart依赖的其他chart,假设依赖redis,如下

  **charts/
  └── redis
    ├── Chart.yaml
    ├── README.md
    ├── templates
    │  ├── NOTES.txt
    │  ├── _helpers.tpl
    │  ├── configmap.yaml
    │  ├── headless-svc.yaml
    │  ├── redis-statefulset.yaml
    │  ├── redis-svc.yaml
    │  ├── redis-serviceaccount.yaml
    │  └── secret.yaml
    └── values.yaml**

  每次安装此chart时，Redis chart都会作为其一部分进行安装。

  同时还可以chart.yaml中（**dependencies:** ）指定依赖的chart,然后就可以使用**helm dependency update**来更新依赖

+ **templates/tests**

  chart还可以包含测试。chart测试用于确定您的安装是否正常。 

  通过chart测试，您可以指定 Pod 或 Job 来运行自定义命令。该命令可以像检查 Web 服务器是否正在侦听端口一样简单，也可以像运行全套验收测试一样深入。由您决定测试成功或失败意味着什么。 

  例如，您可以测试您的 Web 服务器是否向特定端点返回一些“200 OK”响应，指示系统连接。使用chart测试，您可以针对此端点运行简单的**curl**或**wget命令，验证您的安装是否正常。**

  **要创建测试，请按照与在templates/目录中定义任何其他****.yaml**文件完全相同的方式定义 Pod 定义。如果资源元数据中包含以下注解信息（**"helm.sh/hook": test-success**），Helm 会将其识别为测试文件：

+ 有关其他的文件详细信息，请参阅其他资料

#### Helm Chart Templating

根据**values.yaml**和**templates/**目录的内容，图表被“转换”为 Kubernetes 可以理解的原始 YAML。此过程称为**模板化**。但这是如何运作的呢？

我们手动创建一个目录simpleton(包含必要的文件){其实和helm  create  simpleton是效果一致的}

```yaml
root@master01:~/helm-install/simpleton# cat *.yaml 
name: simpleton
version: 1.0.0
apiVersion: v2
image:
  repo: busybox
  tag: 1.31.1
message: hello world
root@master01:~/helm-install/simpleton# cat Chart.yaml 
name: simpleton
version: 1.0.0
apiVersion: v2
root@master01:~/helm-install/simpleton# cat values.yaml 
image:
  repo: busybox
  tag: 1.31.1
message: hello world
root@master01:~/helm-install/simpleton# cat templates/pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: {{ .Chart.Name }}-{{ .Release.Name }}
spec:
  containers:
  - name: {{ .Chart.Name }}
    image: {{ .Values.image.repo }}:{{ .Values.image.tag }}
    command: [ "/bin/sh", "-c", "--" ]
    args: [ "while true; do echo {{ .Values.message }} && sleep 10; done;" ]
#我们可以使用设个命令来生成具体的信息
root@master01:~/helm-install# helm template simpleton/ 
---
# Source: simpleton/templates/pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: simpleton-release-name
spec:
  containers:
  - name: simpleton
    image: busybox:1.31.1
    command: [ "/bin/sh", "-c", "--" ]
    args: [ "while true; do echo hello world && sleep 10; done;" ]
#然后将simpleton chart安装到kubernetes集群中
root@master01:~/helm-install# helm install hello simpleton/ 
root@master01:~/helm-install# kubectl    logs   simpleton-hello   -f  
hello world
hello world
hello world
hello world
#helm install goodbye simpleton/ --set message="Goodbye"（覆盖values.yaml中的单个值）
root@master01:~/helm-install# kubectl    logs   simpleton-goodbye -f  
Goodbye
Goodbye

```

### Chart Repositories

Helm 图表可以从多个来源安装。我们之前都是从本地目录安装的。**但是，也可以从图表存储库**下载图表。

Chart Repositories是简单的 Web 服务器，其中包含可供下载的 Helm 图表。它们包含**repository index**，其中列出了存储库中的每个图表，使您能够搜索存储库中可用的图表。

使用图表存储库的第一步是确定存储库的根 URL。在后面，我们将讨论 Helm Hub，以及如何查找这些 URL。在此，我们将使用*Bitnami*图表存储库，其中包含许多精心构建的图表。对于 Bitnami 存储库，根 URL 是[htt‌ps://charts.bitnami.com/bitnami](https://trainingportal.linuxfoundation.org/learn/course/managing-kubernetes-applications-with-helm-lfs244/helm-charts/downloading-charts-from-public-chart-repositories?page=1)。

```
#知道存储库 URL 后，使用 Helm 添加存储库，为其指定一个将被引用的唯一名称，例如“bitnami”：
$ helm repo add bitnami htt‌ps://charts.bitnami.com/bitnami
#如果想查看bitnami存储库中可用的所有图表：
$ helm search repo bitnami/
#搜索特定的应用
$ helm search repo wordpress
#下载特定的chart
$ helm pull bitnami/wordpress
#这个命令可以查看chart的内同
$ helm pull bitnami/wordpress --untar

```

#### Helm Hub

为了帮助开发 Helm 图表的组织接触到目标受众，Helm 项目托管了一个名为[Helm Hub 的](https://hub.helm.sh/)网站，该网站维护着一系列公开可用的图表存储库

```shell
root@master01:~/helm-install# helm repo add bitnami https://charts.bitnami.com/bitnami  
"bitnami" has been added to your repositories
root@master01:~/helm-install# helm  install    my-wordpress  bitnami/wordpress   --version 17.1.6      --set   service.type=NodePort   --set  service.nodePorts.http=30001   
NAME: my-wordpress
LAST DEPLOYED: Tue Sep  5 02:51:17 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 17.1.6
APP VERSION: 6.3.1

** Please be patient while the chart is being deployed **

Your WordPress site can be accessed through the following DNS name from within your cluster:

    my-wordpress.default.svc.cluster.local (port 80)

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

   export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services my-wordpress)
   export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
   echo "WordPress URL: http://$NODE_IP:$NODE_PORT/"
   echo "WordPress Admin URL: http://$NODE_IP:$NODE_PORT/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace default my-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
root@master01:~/helm-install# helm list   
NAME        	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
my-wordpress	default  	1       	2023-09-05 02:51:17.483117672 +0800 CST	deployed	wordpress-17.1.6	6.3.1      

```

### Application Lifecycle

使用图表模板中的控制结构来构建动态 YAML 清单。说明如何使用自定义**values.yam**有效管理各种环境的配置。

我们将介绍如何使用**chart  hook**，这是一项高级 Helm 功能，允许您在版本生命周期的某些点进行干预。

学习目标：

+ 使用动态模板构建强大的 Helm 图表。
+ 使用值文件定义特定于环境的配置
+ 使用**chart  hook**在发布生命周期中的策略点执行操作
+ 使用 Helm 管理 Kubernetes 上应用程序的整个生命周期

下面介绍Helm 管理的基于 Python 的示例 Web 应用程序的生命周期，以及用于安装、升级、测试、回滚、描述和删除应用程序的各种命令和选项

```shell
一.部署第一个大版本
1.首先我们先构建一个镜像（可以在jenkins agent构建）
root@docker-agent:~/workspace# ll
total 16
drwxr-xr-x  3 root root   75 Jul 16  2020 ./
drwxr-xr-x 21 root root 4096 Oct 16 15:00 ../
-rw-r--r--  1 root root  111 Jul  8  2020 Dockerfile
-rw-r--r--  1 root root 1068 Jul  8  2020 index.html
drwxr-xr-x  3 root root   60 Jul 16  2020 quotegen/
-rw-r--r--  1 root root 1666 Jul  8  2020 server.py
root@docker-agent:~/workspace# docker  build    -t harbor.forcecs.com:32415/python3/quotes:v1  .
root@docker-agent:~/workspace# docker push  harbor.forcecs.com:32415/python3/quotes:v1
2.接下来利用quotegen来release我们的第一个应用
root@master01:~/workspace# helm install  quotegen-prod quotegen    -n py 
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 15:19:39 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
3.运行部署的应用
root@master01:~/workspace# helm   -n py test quotegen-prod   --timeout=30s  
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 16:31:05 2023
NAMESPACE: py
STATUS: deployed
REVISION: 1
TEST SUITE:     quotegen-prod-api-test
Last Started:   Mon Oct 16 16:36:52 2023
Last Completed: Mon Oct 16 16:36:58 2023
Phase:          Succeeded
4.升级应用程序的版本
root@master01:~/workspace# cat  quotegen/values.yaml 
image:
  repo: harbor.forcecs.com:32415/python3/quotes
  tag: v1

env:
  FONT_SIZE: 20

replicas: 2

service:
  type: NodePort
  port: 31101
root@master01:~/workspace# helm -n py upgrade  quotegen-prod quotegen   --set env.FONT_SIZE=80 
Release "quotegen-prod" has been upgraded. Happy Helming!
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 17:09:51 2023
NAMESPACE: py
STATUS: deployed
REVISION: 2
root@master01:~/workspace# helm -n py   status   quotegen-prod  
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 17:09:51 2023
NAMESPACE: py
STATUS: deployed
REVISION: 2
二.升级大版本
修改源代码之后，镜像的版本变为v2
1.升级版本
root@master01:~/workspace# helm -n py upgrade  quotegen-prod quotegen  --reuse-values --set    image.tag=v2 
Release "quotegen-prod" has been upgraded. Happy Helming!
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 17:41:25 2023
NAMESPACE: py
STATUS: deployed
REVISION: 3
2.测试
root@master01:~/workspace# helm   -n py  test  quotegen-prod --timeout=30s 
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 17:41:25 2023
NAMESPACE: py
STATUS: deployed
REVISION: 3
TEST SUITE:     quotegen-prod-api-test
Last Started:   Mon Oct 16 17:42:08 2023
Last Completed: Mon Oct 16 17:42:38 2023
Phase:          Failed
Error: 1 error occurred:
	* timed out waiting for the condition
3.失败后恢复到上一个版本
root@master01:~/workspace# helm  -n py rollback  quotegen-prod   2 
Rollback was a success! Happy Helming!
root@master01:~/workspace# helm   -n py  test  quotegen-prod --timeout=30s  
NAME: quotegen-prod
LAST DEPLOYED: Mon Oct 16 17:58:07 2023
NAMESPACE: py
STATUS: deployed
REVISION: 4
TEST SUITE:     quotegen-prod-api-test
Last Started:   Mon Oct 16 17:58:23 2023
Last Completed: Mon Oct 16 17:58:29 2023
Phase:          Succeeded
三。卸载版本
root@master01:~/workspace# helm   -n py    uninstall   quotegen-prod 
root@master01:~/workspace# kubectl    -n py get  pods  
NAME                                  READY   STATUS        RESTARTS   AGE
quotegen-prod-5cf6dddd4-g4zsg         1/1     Terminating   0          2m50s
quotegen-prod-5cf6dddd4-v294h         1/1     Terminating   0          2m51s
quotegen-prod-api-test-4xxzm          0/1     Completed     0          2m35s
quotegen-prod-pre-delete-hook-jljwd   0/1     Completed     0          20s
```

具体的一些其他介绍（Templating Techniques，特定环境的配置，hook等请自行查阅相关资料）

### Other

我们即将了解：

- 使用启动器自定义创建新charts
- 建立chart library，共享常用辅助工具。
- 了解 Helm 插件如何扩展 Helm CLI。
- 使用provenance files签署和验证图表包
- 托管和维护自己的chart repository

#### Starter Charts

假设我们的入门chart就是上边的例子**quotegen**

**quotegen/
├── Chart.yaml
├── templates
│  ├── _helpers.tpl
│  ├── deployment.yaml
│  ├── ingress.yaml
│  └── service.yaml
└── values.yaml**

替换tmpplate下的文件的硬编码的值（quotegen替换为<CHARTNAME>，尤其是_helpers.tpl）

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "<CHARTNAME>.fullname" . }}
  labels:
    {{- include "<CHARTNAME>.labels" . | nindent 4 }}
...
```

Once you are happy with your starter chart, you must make sure it is present in the **$XDG_DATA_HOME/helm/starters** directory (on Linux, the default for **XDG_DATA_HOME** is **$HOME/.local/share**). Copy your chart manually into the proper location (making sure the **starters** directory exists first):

```
root@master01:~# mkdir -p $HOME/.local/share/helm/starters  
root@master01:~# cp -r workspace/quotegen $HOME/.local/share/helm/starters  
root@master01:~/.local/share/helm/starters# pwd
/root/.local/share/helm/starters
root@master01:~/.local/share/helm/starters# ls
quotegen
```

接下来使用**statrt chart**,来生成一个新的chart（区别与helm  create xxxx  ）

```
root@master01:~# helm create --starter quotegen  mychart
root@master01:~# ls  mychart/templates/
NOTES.txt  _helpers.tpl  api-test.yaml  deployment.yaml  hpa.yaml  ingress.yaml  pre-delete-hook.yaml  service.yaml  serviceaccount.yaml  tests
```

#### Library Charts

library chart是特殊类型的 Helm 图表，其中包含要在其他图表中使用的定义。例如，您可以使用library chart来创建要在图表模板中使用的新函数

**NOTE: **library chart无法创建

##### 创建library chart

为了将图表表示为library chart，请将**Chart.yaml**中的type**字段设置为**library**。以下是library chart的**Chart.yaml示例：

```yaml
name: mylib
version: 0.1.0
apiVersion: v2
type: library
```

另一个显着的区别是库图表不包含**values.yaml**文件或任何实际模板。**相反，库图表在templates/**目录下包含以下划线 ( **_** )前缀的**.yaml**或**.tpl**文件。***\*templates/\****目录中以下划线 ( **_** )开头的文件预计不会生成任何 Kubernetes 清单。

**以下是一个名为mylib**的简单示例库图表的结构：

**mylib/
├── Chart.yaml
└── templates
  └── _utils.tpl**

文件**templates/_utils.tpl**将用于定义实用程序帮助程序，供我们在其他图表中使用。举例来说，我们将在此文件中定义一个帮助程序，**companyLabels**，它返回应出现在您公司拥有的所有 Kubernetes 资源上的标签。

**以下是templates/_utils.tpl**的内容：

```yaml
{{- define "mylib.companyLabels" -}}
builtByCompany: "true"
{{- end }}
```

通过在其他图表中使用此助手，系统管理员将能够查询公司构建的 Kubernetes 集群资源。

##### 使用库图表作为依赖项

Now that we have a library chart to work with (**mylib**), we need to first list it as a dependency in order to use it.

Let’s consider this library chart has been published to a chart repository located at http://localhost:8000 (see the lab in this chapter for how to host a chart repository).

In a new chart, we can list this dependency under the **dependencies** section in **Chart.yaml**. Here is the **Chart.yaml** for a new chart, **mychart**, which will leverage the **mylib** library chart:

```yaml
name: mychart
version: 1.0.0
apiVersion: v2
type: application
dependencies:
- name: mylib
  version: 0.1.0
  repository: http://localhost:8000
```

Notice also that for this chart, the **type** field is set to **application**, denoting this as a normal, installable chart.

Here is the structure of the **mychart** chart:

**mychart/
├── Chart.yaml
├── templates
│  ├── _helpers.tpl
│  └── configmap.yaml
└── values.yaml**

This chart contains a single template, **configmap.yaml**, which defines a simple Kubernetes configmap. In this template, we will leverage the **companyLabels** helper defined in the library chart.

Here are the contents of **templates/configmap.yaml**:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
 name: {{ include "mychart.fullname" . }}
 labels:
  {{- include "mylib.companyLabels" . | nindent 4 }}
  {{- include "mychart.labels" . | nindent 4 }}
data:
 mykey: {{ .Values.myval | quote }}
```

现在要使用这个图表mychart，我们必须首先获取**mylib**依赖项。为此，我们使用**helm dependency update**命令：

```shell
$ helm dependency update mychart/

Saving 1 charts
Downloading mylib from repo http://localhost:8000
Deleting outdated charts
之后的结构如下，从远程资源库获取 mylib 库图表压缩包，并将其放入 charts/ 子目录。此外，还创建了一个 Chart.lock 文件，其中包含下载的依赖项信息。

下面是运行 helm 依赖项更新后图表的新结构：
mychart/
├── Chart.lock
├── Chart.yaml
├── charts
│   └── mylib-0.1.0.tgz
├── templates
│   ├── _helpers.tpl
│   └── configmap.yaml
└── values.yaml

```

现在，我们已经收集了依赖项（mylib），可以安装我们的图表了：

```shell
$ helm install mychart-demo mychart/**

然后，如果我们检查创建的 configmap，我们应该看到**builtByCompany**标签被正确设置为**true**：

$ kubectl get configmap mychart-demo --label-columns=builtByCompany
```

#### Plugins

请自行搜索相关资料

#### 附：

```shell
#创建应用程序存储库
root@master01:~/cncf# helm   create    mychart                        
root@master01:~/cncf# mkdir  -p   lab 
#打包chart到lab目录
root@master01:~/cncf# helm  package  mychart -d lab/                   
Successfully packaged chart and saved it to: lab/mychart-0.1.0.tgz
#在lab中创建新的index.heml文件   
root@master01:~/cncf# helm   repo  index  lab/                                   
root@master01:~/cncf# ls
lab  mychart  workspace
root@master01:~/cncf# cd lab/
root@master01:~/cncf/lab# ls
index.yaml  mychart-0.1.0.tgz
root@master01:~/cncf/lab# cat index.yaml 
apiVersion: v1
entries:
  mychart:
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:23:29.325510735+08:00"
    description: A Helm chart for Kubernetes
    digest: 033df9627ae05c48c82c6307dd599eb9aacdf51be1b8987eef92ad4b46bf0ac2
    name: mychart
    type: application
    urls:
    - mychart-0.1.0.tgz
    version: 0.1.0
generated: "2023-10-16T14:23:29.325041443+08:00"


接下来更新存储库的版本
root@master01:~/cncf# sed  -i 's/^version:.*$/version: 0.2.0/'  mychart/Chart.yaml
再次进行打包
root@master01:~/cncf# helm  package mychart/  -d lab/
Successfully packaged chart and saved it to: lab/mychart-0.2.0.tgz
#再次生成新的索引
root@master01:~/cncf# helm   repo index  lab/
root@master01:~/cncf# cat  lab/index.yaml 
apiVersion: v1
entries:
  mychart:
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:32:32.086575403+08:00"
    description: A Helm chart for Kubernetes
    digest: c039a74da4dfa9e9fbf4f43851a27e5dcd14a8ed3ef98a169bab06c413e3d96c
    name: mychart
    type: application
    urls:
    - mychart-0.2.0.tgz
    version: 0.2.0
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:32:32.086173963+08:00"
    description: A Helm chart for Kubernetes
    digest: 033df9627ae05c48c82c6307dd599eb9aacdf51be1b8987eef92ad4b46bf0ac2
    name: mychart
    type: application
    urls:
    - mychart-0.1.0.tgz
    version: 0.1.0
generated: "2023-10-16T14:32:32.085642404+08:00"
--------------
root@master01:~/helm-2# helm   create  otherchart  
Creating otherchart
root@master01:~/helm-2# ll
total 8
drwxr-xr-x  3 root root   24 Oct 16 14:39 ./
drwx------ 24 root root 4096 Oct 16 14:38 ../
drwxr-xr-x  4 root root   93 Oct 16 14:39 otherchart/
root@master01:~/helm-2# mkdir workspace 
root@master01:~/helm-2# helm package  otherchart/  -d workspace/
Successfully packaged chart and saved it to: workspace/otherchart-0.1.0.tgz
root@master01:~/helm-2# helm repo index  --merge   /root/helm-1/lab/index.yaml   workspace/ 
root@master01:~/helm-2# cat workspace/index.yaml 
apiVersion: v1
entries:
  mychart:
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:32:32.086575403+08:00"
    description: A Helm chart for Kubernetes
    digest: c039a74da4dfa9e9fbf4f43851a27e5dcd14a8ed3ef98a169bab06c413e3d96c
    name: mychart
    type: application
    urls:
    - mychart-0.2.0.tgz
    version: 0.2.0
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:32:32.086173963+08:00"
    description: A Helm chart for Kubernetes
    digest: 033df9627ae05c48c82c6307dd599eb9aacdf51be1b8987eef92ad4b46bf0ac2
    name: mychart
    type: application
    urls:
    - mychart-0.1.0.tgz
    version: 0.1.0
  otherchart:
  - apiVersion: v2
    appVersion: 1.16.0
    created: "2023-10-16T14:43:13.553348437+08:00"
    description: A Helm chart for Kubernetes
    digest: 8b304a8ce38a1ae77f5bede986af53f4d90d2ecfe6b548d438406137eef54e7e
    name: otherchart
    type: application
    urls:
    - otherchart-0.1.0.tgz
    version: 0.1.0
generated: "2023-10-16T14:43:13.552857335+08:00"
#合并索引并且移动版本
root@master01:~/helm-2# mv /root/helm-1/lab/*.tgz  workspace/
root@master01:~/helm-2# ll workspace/
total 16
drwxr-xr-x 2 root root  102 Oct 16 14:45 ./
drwxr-xr-x 4 root root   41 Oct 16 14:40 ../
-rw-r--r-- 1 root root 1028 Oct 16 14:43 index.yaml
-rw-r--r-- 1 root root 3762 Oct 16 14:21 mychart-0.1.0.tgz
-rw-r--r-- 1 root root 3761 Oct 16 14:30 mychart-0.2.0.tgz
-rw-r--r-- 1 root root 3761 Oct 16 14:40 otherchart-0.1.0.tgz


```

