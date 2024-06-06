[TOC]

# Explain Consul Architecture

**Objective 1a:** 识别 Consul 数据中心的组件，包括代理和通信协议

**Objective 1b:** 为 Consul 的高可用性和高性能做好准备

**Objective 1c:** 确定 Consul 的核心功能

**Objective 1d:** 区分代理角色

**HashiCorp Consul 解决的问题**

HashiCorp Consul 是一个用于服务发现、配置管理和服务网格的工具，它主要解决以下问题：

**1. 服务发现：**

- **动态服务注册和发现：** Consul 提供了一个中央存储库，用于注册和发现应用程序。应用程序可以在 Consul 中注册自己，Consul将这些注册存储在服务注册表中，从而启用服务发现。而应用程序可以查询 Consul 来发现可用服务。
- **服务健康检查：** Consul 提供了健康检查机制，可以监控服务健康状况。如果服务不可用，Consul 将将其从服务发现列表中移除，确保应用程序只与健康服务通信。
- **服务路由：** Consul 支持多种服务路由策略，例如轮询、随机和加权路由。这使得应用程序可以根据需要选择最佳服务。

**2. 配置管理：**

- **集中式配置存储：** Consul 可以作为集中式配置存储库，存储应用程序的配置数据。
- **配置版本控制：** Consul 提供了配置版本控制机制，允许您回滚到之前的配置版本。
- **动态配置更新：** Consul 允许您动态更新应用程序的配置，而无需重新启动应用程序。

**3. 服务网格：**

- **服务间通信：** Consul 提供了服务网格功能，允许服务之间进行安全和可靠的通信。
- **流量管理：** Consul 支持多种流量管理功能，例如负载均衡、断路器和速率限制。
- **安全通信：** Consul 支持 TLS 协议，确保服务之间通信的安全性。

**4. 可扩展性和高可用性：**

- **分布式架构：** Consul 采用分布式架构，可以轻松扩展到大型环境。
- **多数据中心支持：** Consul 支持多数据中心，允许您将应用程序部署到多个地理位置。
- **高可用性：** Consul 提供了高可用性机制，确保即使在某些节点出现故障的情况下也能正常运行。

**5. 集成：**

- **与其他工具集成：** Consul 可以与其他工具集成，例如 Docker、Kubernetes 和 Terraform。
- **多平台支持：** Consul 支持多种平台，包括 Linux、Windows 和 macOS。

## Service Discovery

+ Centralized Service Registry
  + 服务之前通信的单一联络点
  + 动态工作负载非常重要 (such as containers)
  +  对微服务架构尤为重要
+ Reduction or elimination of load balancers to front-end services
  + Frequently referred to as east/west traffic

+ Real-time health monitoring

  每当部署这些微服务的时候，consul agent都会向控制台注册自己。

  如果它们不健康，控制台将不会回复 其中一个服务的API 请求或不健康的 DNS 请求

  <img src="C:./img/1.png" alt="1" style="zoom:50%;" />

  + Distributed responsibility throughout the cluster
  + Local agent performs query on services
    + Node-level health checks
    + Application-level health checks

+ Automate networking and security using identity-based authorization

  <img src="C:./img/2.png" alt="2" style="zoom:50%;" />

  现在，服务发现再次允许我们通过使用**基于身份**的方式来自动化网络和安全性，以前没有控制台的授权，可能在本地，甚至在云端

  + no more IP-based or firewall-based security

#### Service Discovery – Multi-DC

<img src="C:./img/3.png" alt="3" style="zoom:50%;" />

现在，我们来谈谈多数据中心，并且可能是Azure中的一个数据中心。

也许我们在 Azure 有一个网络服务和一个数据库服务，在 AWS 有一个冗余网络服务和一个数据库服务。当然，这两者之间的连接是紧密耦合的。
现在，控制台还支持网状网关等功能，以实现 Azure 和 AWS 之间的连接。
在这个例子中，两者之间不需要实际的网络连接。
因此，这将跨越公共互联网。
总之，这里发生的情况是，我们可能有一个用户，该用户需要访问网络服务。
因此，用户会打开浏览器进行操作。
网络服务依赖于后端数据库服务器。
因此，当向网络服务发出请求时，网络服务实际上会向控制台发出请求:
说："嘿，我需要连接到我的数据库。数据库做出响应后，最终用户就可以访问网站了。

但是，如果在这种情况下 Azure 中的数据库服务器宕机了，会发生什么情况？
当用户想要刷新或其他用户连接到此网络服务时会发生什么情况？
那么，如果该用户刷新或其他用户进来访问此网络服务，网络服务
将向控制台发出另一个请求。
控制台就会意识到本地数据库服务宕机了，它将引导网络服务连接到其他数据库服务。
连接到其他数据库服务。没错。
在这种情况下，如果用户刷新或其他用户继续访问 Web 服务、
网络服务就会使用其他数据库服务，因为 Console 知道本地数据库服务
已经关闭。
因此，这就是我们为应用程序提供多数据中心可用性的一种方法，无论它是
还是跨云，我们都可以为应用程序提供多数据中心可用性。

## Service Mesh

+ Enables secure communication between services
  + Integrated mTLS secures communication
  + Uses sidecar architecture that is placed alongside the registered service
  + Sidecar (Envoy, etc.) transparently handles inbound/outbound connections 

+ Defined access control for services
  + Defines which service can establish connections to other services

服务网格可以帮助我们实现服务间的安全通信。
如果需要，它还能帮助我们拒绝服务间的通信。
为此，我们集成了mutual TLS，以确保服务间通信的安全。
现在，这将使用sidecar architecture，sidecar architecture被放置在注册服务的旁边。

因此，举例来说，如果我们有一个运行在容器上的网络服务，我们也可能会有一个与该注册服务同时运行的 envoy代理，与注册服务同时运行。
该代理负责引导网络服务与其他服务之间的流量，或引导来自其他服务的入站连接。

现在，sidecar 通常可以为我们透明地处理入站和出站连接。
大多数时候，应用程序甚至不知道它的存在。
没错。所以这很酷。我们可以启用这种通信。我们可以在应用程序甚至不知道它存在的情况下启用这一功能。

通过控制台，我们可以定义服务的访问控制。
这样做的目的是定义哪些服务可以与其他服务建立连接。
因此，举例来说，如果我们有一个支付服务，我们可能不希望其他服务与该支付服务通信，因为该支付服务可能会与其他服务通信。
因为支付服务可能包含信用卡号等敏感数据
没错。
因此，我们可以使用服务网格，只为需要与支付服务通信的服务启用连接，而限制其他不需要与支付服务通信的服务。

现在，这一切都可以在没有防火墙的情况下完成，这就是服务网格的全部意义所在，它可以无需频繁更新防火墙上的防火墙规则。

<img src="C:./img/4.png" alt="4" style="zoom:50%;" />

这里有我们的控制台服务器，也许还有一个电子商务网站。
现在，当每个微服务出现时，它们都会在控制台注册。
所以，我们在中间有一个控制台服务器，我们有一个服务注册表，它知道所有这些服务器。

现在，如果网络服务需要连接到其他服务，它可以连接到控制台
控制台会说，没错，你就是网络服务，所以你可以与搜索服务对话、购物车服务、发货和付款，因为你是网络服务。
这就是你的工作。

不过，也许我们并不希望搜索服务能与支付服务通信。
首先，这可能不是我们的应用程序正常工作所请求的，而且可能不安全。
我们不希望有人潜入搜索服务，并能够访问支付服务。
因此，在这种情况下，我们可以在控制台中创建一个所谓的意图。
该意图规定，搜索服务不能与支付服务对话。

同样，当我们独立扩展所有这些服务时，每次有不同的搜索服务都会在控制台注册。
控制台就会阻止搜索服务和支付服务之间的通信。

<img src="C:./img/5.png" alt="5" style="zoom:50%;" />

在继续研究服务网状结构的同时，让我们来看看它究竟是如何工作的。
现在，控制台服务器位于左侧，底部是五个微服务。
现在，我们的微服务可能已经在控制台注册了。
你可以在左侧看到不同颜色的条形图。

现在的情况是，为了启用这一点，我们的服务当然要在每个容器上运行。
现在，我们要做的就是在每个容器上添加一个特使代理。
现在，服务与容器外部的任何通信都将通过特使代理。

现在，为了建立服务网格或服务分段，控制台本身就成了一个证书授权。
现在，我们要做的就是使用相互 TLS，并为所有客户端提供相互 TLS 证书。

现在，当网络服务要与搜索服务联系时，网络服务会向控制台发出请求，询问与谁对话。
控制台，询问搜索服务控制台的对话对象。

Will 回答说："嘿，请转到这里的蓝色方框，然后容器就会发出请求。
因此，它使用端口 5000 从网络服务转到 Envoy 代理。
代理与搜索服务上的特使代理建立连接，最终将请求发送到搜索服务。
最终到达搜索服务。当然，响应也会按照完全相同的路径返回。
相互 TLS 使通信得以进行。

## Network Automation

+ Dynamic load balancing among services
  + Consul will only send traffic to healthy nodes & services
  + Use traffic-shaping to influence how traffic is sent
+ Extensible through networking partners
  + F5, nginx, haproxy, Envoy
+ Reduce downtime by using multi-cloud and failover for services

现在，这种网络自动化可以让我们通过使用多云和服务故障转移来减少停机时间、
对吗？
因此，如果我们使用多云，而云提供商出现了问题，或者说我们的可用性区域出现了问题，或者类似的情况，网络自动化就能让我们进行故障转移。
如果我们在另一个云或另一个本地数据中心运行相同的服务。
因此，网络自动化允许我们根据工作负载和环境进行第七层流量管理。
因此，我们有能力实现服务、基于故障转移路径的路由选择和流量转移等功能。

+ L7 traffic management based on your workloads and environment

  + service failover, path-based routing, and traffic shifting capabilities

  ![6](C:./img/6.png)

让我们来看看这看起来像什么。
假设我们有一个应用程序，这个应用程序是第一版。
没错。我们有一个用户，用户发出请求说，嘿，我想连接到这个应用程序。
请求转到控制台。控制台回应说，嘿，我想把 100% 的流量发送到第一版应用程序。
用户发出请求后，很高兴。用户可以访问应用程序了。
现在，也许我们部署了应用程序的第二版，也许我们想将所有流量发送到第二版。

现在，我们可以通过向 推送一个策略，流量转到版本二，0% 的流量转到版本一，对吗？
也许我们部署的是版本二。
它已经经过测试，我们想继续向客户推送。
因此，这是一种简单的方法，我们可以轻松地进行故障转移或故障转移到新版本的应用程序。

控制台还允许我们增加服务之间的第七层可见性。
这些指标包括连接、超时、开放线路等。
现在，特使代理启用了这些功能。
我们可以将所有这些第七层统计数据发送到 Grafana 等工具。
现在，我们可以使用 StatsD、Dogstatsd 或 Prometheus 等工具将所有这些统计数据发送到 Grafana。
我们可以为不同的应用创建仪表盘，并用它来监控环境中的所有这些指标。在我们的环境中。

## Service Configuration

+ Consul provides a distributed K/V store 
+ All data is replicated across all Consul servers
  + All data is replicated across all Consul servers
  + It is NOT a full featured datastore (like DynamoDB)

+ Can be accessed by any agent (client or server)
  + Accessed using the CLI, API, or Consul UI
  + Make sure to enable ACLs to restrict access (Objective 8)

+ No restrictions on the type of object stored
+ Primary restriction is the object size – capped at 512 KB
+ Doesn't use a directory structure, although you can use / to organize your data within the KV store
  + / is treated like any other character
  + This is different than Vault where / signifies a path

现在，控制台为我们提供了一个分布式 KV 存储，对吗？
所有这些数据都会在所有控制台服务器上复制。
因此，当你向控制台写入数据时，所有数据都会在所有控制台服务器上复制。
因此，我们的集群中存在冗余。
现在，服务配置或洞穴存储可用于存储配置和参数，或真正的洞穴存储内的任何内容。但大多数情况下，它是用来为我们的应用程序存储配置和参数的。
现在请注意，它并不像 DynamoDB 那样是一个功能齐全的数据存储库，尽管它确实有一些类似于 DynamoDB 的功能。

任何代理都可以访问洞穴存储，无论是客户端还是服务器。
它可以通过 CLI、API 进行访问，你甚至可以登录用户界面，浏览控制台洞穴。浏览控制台洞穴。使用 KV 时，请确保启用 ACL，以限制对数据的访问。
你最不希望看到的就是有人登录控制台浏览 KV 存储并删除你不想删除的数据。
因此，请确保启用 ACL。

现在，控制台对存储对象的类型没有限制。
不过，我们有一个限制，那就是对象的大小。
对象大小的上限是 512 KB。尽管可以使用斜线来组织洞穴存储区内的数据，但控制台并不使用目录结构。洞穴存储中的数据。
因此，正斜线的处理方式与其他字符无异，但很多人会使用正斜线来将其分开。
斜线来分割数据。
因此，它看起来就像操作系统上的一个目录。这也与 Vault 不同，Vault 使用斜线表示特定路径。
同样，大多数人会使用这个斜线来组织控制台中的东西，但只要要知道，这并不一定是一个目录结构。它只是一种模拟。

![7](C:./img/7.png)

让我们来看看这看起来像什么。
我们可能有自己的培训应用程序，对吗？
我们有三个实例，即我们要部署的培训应用程序。
现在，这个培训应用程序可能需要一些变量才能正确部署，对吗？
这些变量可能是数据库的连接字符串、我们要部署的应用程序版本、我们要部署的数据库中的表，等等。
好的。

因此，我们可以将这些变量存储在控制台的 KV 存储区中，然后我们就可以有
比如 Jenkins 或 Circleci 或其他自动化或协调工具。
它可以连接到控制台 KV 存储，从控制台 KV 存储中检索数据，然后
它可以使用这些数据来部署我们的应用程序。
当我们继续更新应用程序时，我们可以更新控制台 KV 存储中的参数，然后
同样，我们的自动化工具可以读取这些参数，并将更改部署到我们的应用程序中。

## Basic Consul Architecture

<img src="C:./img/8.png" alt="8" style="zoom:50%;" />

现在，控制台代理可以配置为在所谓的服务器模式或客户端模式下运行。
这种配置由控制台配置文件决定，也可以通过控制台代理启动时传递给它的命令行参数来配置。控制台代理也可以在所谓的开发模式下运行。开发模式通常是本地运行控制台的模式，例如在笔记本电脑上进行测试。

<img src="C:./img/9.png" alt="9" style="zoom:50%;" />

控制台代理可以运行的不同模式对于部署控制台集群至关重要。
左侧是以服务器模式运行控制台代理的控制台实例。
这种类型的控制台实例通常被称为控制台服务器，但你也可能会看到
服务器模式的服务器代理，或者只是一个控制台节点。

现在，在右侧我们有一堆客户端。
这些客户端是我们环境中运行控制台代理的其他虚拟机或容器。

这些客户端的主要目的是为我们的组织提供某种类型的服务
这可能是网络服务器，也可能是某种类型的微服务，还可能是数据库实例。
每个客户端都在客户端模式下运行控制台代理，它们将与服务器
节点进行交互，比如注册服务。

它可以为其他服务发送 DNS 或 API 请求，也可以更新本地托管服务的健康检查。
虽然这些客户端通常被称为控制台客户端，但你也可能听到它们被称为
在典型的控制台部署中，它们也被称为以客户端模式运行的节点或客户端代理。

<img src="C:./img/10.png" alt="10" style="zoom:50%;" />

**Server：**

一般来说，你只需要几个控制台服务器节点，而这些客户端可能有成百上千个。
那么，控制台代理的每种模式都能为我们提供什么呢？

我们先从服务器模式开始。
控制台服务器通常是控制台集群的成员，负责了解整个控制台集群的状态。
服务器还负责管理控制台环境的成员资格，因此要了解谁是控制台环境的成员
不管是服务器还是客户端。
服务器还会维护每个成员的记录，并根据环境中发生的情况经常更新记录。
虽然你会听到我说多台服务器创建了一个群集，但实际上整个控制台环境

服务器节点的另一个主要职责是响应 DNS 或 API 查询
例如，在我们的微服务架构中，前端服务可能会向控制台发送查询，询问如何与该支付服务通信。
现在，控制台服务器节点负责用正确的信息回复该查询，以便服务之间能成功通信。
这样服务之间才能成功通信。

说到服务，服务器节点还要注册服务。
这就是之前在介绍部分讨论过的服务注册。现在，这些都是基于客户端提供的信息。
一旦客户端希望注册本地服务，它就会向服务器发送请求，而服务器
就会在其服务注册表中记录服务注册信息。

现在，一旦这样做了，其他服务就可以向控制台发送针对该特定服务的查询，因为
现在控制台已经知道了这项新服务。

服务器节点还负责维护所谓的法定人数。
我们稍后会详细介绍法定人数，但总的来说，法定人数就是在所谓的
这将直接影响控制台集群内的高可用性和集群领导力。
最后，服务器还负责作为网关，连接企业内可能部署控制台的其他数据中心。

**Client**

正如我们所讨论的，客户端通常是实例或容器或任何其他物理服务器

现在，客户端一旦加入集群，几乎总是会在控制台注册一个服务。
注册服务的目的也是为了让我们组织内的其他服务能发现
并与注册的服务通信。
控制台客户端还会对整个节点或仅注册的服务执行健康检查。
这样，控制台就能了解它是否健康，是否应该接收流量。
由于客户端不是服务器，它们实际上会将所有 RPC 调用转发给服务器，由服务器进行处理。

具有Takes Part in LAN Gossip Pool 功能，Consul 客户端会积极参与 gossip 协议，与其他节点交换信息，例如：节点状态,服务信息,KV 存储数据,提高信息传播效率，加速节点发现和服务注册

同时客户端代理也是无状态的

<img src="C:./img/11.png" alt="11" style="zoom:50%;" />

现在，当我们谈论控制台中的数据中心时，我们谈论的是在物理或区域位置内共同工作的控制台
服务器和客户端在一个物理或区域位置内协同工作的结果。
通常情况下，控制台数据中心位于单一物理位置的范围内。
因此，类似于你的本地数据中心，或者如果你将控制台部署到公共云上，那么它
通常定义为一个区域，该区域可能包含多个控制台可用性区域。

<img src="C:./img/12.png" alt="12" style="zoom:50%;" />

**数据中心是什么：**

控制台数据中心的真正定义是什么？
首先，控制台数据中心由单个控制台集群组成。
该控制台集群有一个或多个服务器，并与作为该控制台集群成员的客户端进行通信。

如果你碰巧拥有多个控制台集群，那么根据定义，你就拥有多个控制台数据中心。
数据中心对企业来说也是私有的，不对外开放。控制台数据中心旨在处理应用程序的内部通信，而不是用于外部通信。

现在，您可能在控制台数据中心内拥有支持这些外部服务的内部组件。
但这些 DNS 和 API 查询是用于私人通信的。
数据中心由可以通过低延迟、高带宽连接进行通信的成员组成
现在，公共云提供商的区域，如 AWS、美国东部的一个由
多个可用区，这些可用区之间已经拥有低延迟、高带宽的连接。
因此，作为控制台数据中心，多可用区部署是可以接受的。
在数据中心内使用多个可用区进行冗余。

现在，控制台群集还有一个LAN gossip pool，用于与群集的所有成员进行通信。
但我们要知道，每个控制台数据中心本身都有自己的 LAN gossip pool

**数据中心不是什么：**

现在，单一数据中心不是多地区或多地点数据中心。
因此，控制台集群绝不能跨越物理位置的边界，因为延迟会对所有控制台集群之间的通信和复制产生负面影响。影响所有服务器节点之间的通信和复制。
控制台数据中心不包含多个群集。它只包含一个群集。

控制台数据中心不使用 WAN gossip pool
最后，控制台数据中心不使用某种权衡连接或跨互联网进行通信。

#### Multi-Datacenter

<img src="C:./img/13.png" alt="13" style="zoom:50%;" />

现在，多数据中心就像它听起来一样，我们有多个控制台数据中心，它们
相互通信。现在，这可以是两个物理数据中心。
可以是 GCP 或其他云提供商的数据中心，也可以是在同一云平台上运行的两个不同区域。如果需要，甚至可以是部署在同一物理数据中心的两个控制台数据中心。

现在，虽然这里的可能性几乎是无穷无尽的，但这里的重点是，你有一个以上的
数据中心进行通信，因此一个数据中心的客户端可以开始与另一个数据中心的控制台客户端进行交互。

现在，这通常是为了类似故障转移的目的。
因此，如果主数据中心的搜索服务宕机，而辅助数据中心也在运行，我们就可以
将我们的应用程序指向第二个数据中心的搜索服务。
如果主数据中心宕机，或者某些服务只在某个数据中心运行，而客户端需要相互交互。
同样，这里有大量的可能性，但只要知道多数据中心的整个要点
就是，一个控制台数据中心的注册服务可以被另一个控制台数据中心的客户端访问。

在本幻灯片的示例中，我们的主控制台数据中心位于左侧，我们正在与位于顶部的另一个物理数据中心通信。同时还与下方部署在公共云上的另一个数据中心进行通信。

<img src="C:./img/14.png" alt="14" style="zoom:50%;" />

#### Key Protocols

<img src="C:./img/15.png" alt="15" style="zoom:50%;" />

谈谈控制台在引擎盖下使用的两个关键协议
来提供我们迄今为止讨论过的所有功能。

第一个是共识协议，基于 Raft 协议。服务器节点使用该协议进行集群操作。
因此，像领导者选举这样的事情，需要在服务器节点间保持一致的条目，并建立我们之前提到的法定人数。
所有这些操作对于控制台集群都至关重要，而共识协议为我们提供了这种能力。请记住，该协议仅用于服务器节点，客户端不会使用。

第二个关键协议是流言协议。
该流言协议在整个集群范围内使用。
服务器和客户端都将使用闲话协议来管理集群的成员资格，并
建立连接失败等广播信息。所有这些都是通过冲浪来实现的。

## Consensus Protocol (Raft)

更深入的内容请[参考](https://raft.github.io/)

+ Based on Raft
  + Used on only Server nodes (cluster) – not clients
  + Strongly consistent

+ Responsible for
  + Leadership elections
  + Maintaining committed log entries across server nodes
  + Establishing a quorum

我要谈的第一个关键控制台协议是共识协议。
该协议仅由服务器节点使用，任何控制台客户端都不使用。
该协议允许控制台在整个集群中提供高度一致的日志条目。
换句话说，所有日志条目、所有为控制台提供的数据，在任何时候
提交新条目或新变更时，这些数据都会在集群内的所有控制台服务器上复制

这样，如果我们丢失了一个服务器节点，数据仍会在所有其他节点上得到维护
我们不会因为失去一个节点甚至多个节点而丢失数据。
控制台协议负责领导选举等事宜，每个控制台集群都有一个且仅有一个领导者，他基本上负责该集群的所有事务。

共识协议还负责维护跨服务器节点的日志条目，以确保每台服务器都有一致的数据。
确保每台服务器上的数据与领导者更新的数据保持一致。

最后，共识协议还负责建立一个法定人数。
控制台服务需要法定人数才能运行。
如果你还没有完全理解这些内容，也不必担心，因为这只是对协议本身的介绍。
正是这个协议在 1.4 版本中被移植到了 Hashicorp vault 中，从而创建了 Vaults
集成存储功能。

### **Consensus Glossary**

在我们继续讨论 Raft 之前，我想先简单介绍几个术语，以确保我们都在同一起跑线上。

**Log**

日志是工作的主要单位，意味着它是一连串有序的条目。
每个条目都可能是不同的内容。它可能是集群的一个变化，比如一个新的服务器或客户端。也可能是对键值存储的更改，即有人在键值存储中写入、更改或删除了某些内容。这些变化都会写入日志，如果回放这些日志，基本上就等于集群的当前状态。

现在，由于我们要确保所有服务器节点都有相同的数据以保持一致性，因此集群的所有成员必须就日志条目及其顺序达成一致，才能被视为我们所说的一致日志。

+ Primary unit of work – an ordered sequence of entries
+ Entries can be a cluster change, key/value changes, etc.
+ All members must agree on the entries and their order to be considered a consistent log

**Peer Set**

peer set 实际上就是参与日志复制的成员集合。
实际上，根据我们目前所讨论的内容，你应该已经知道只有服务器负责
维护这些日志。
所以你应该猜到，peer set其实就是本地数据中心内的所有服务器节点、
也就是说，控制台服务器本身内部的所有服务器节点。
因此，如果你有一个包含五个服务器节点的控制台集群，那么你的对等集就是这五个服务器节点。

+ All members participating in log replication
+ In Consul’s case, all servers nodes in the local datacenter

**Quorum**

+ Majority of members of the peer set (servers)
+ No quorum = no Consul
+  A quorum requires at least (n+1)/2 members
  + Five-node cluster = (5+1)/2 = 3
  + Three-node cluster = (3+1)/2 = 2

<img src="C:./img/16.png" alt="16" style="zoom:50%;" />

每个控制台服务器节点（此处称为 raft 节点）始终处于三种状态之一

它要么是领导者，要么是追随者，要么是候补者。
因此，当控制台服务器代理第一次上线时，它是一个追随者。
如果没有领导者或现有领导者失效，控制台节点可以投票选举自己或其他节点作为领导者。
如果该节点被选为领导者，它将晋升为群集领导者。
否则，该节点将继续作为追随者。
在这一投票阶段，节点只能处于候选阶段，这通常是
在这里可以用毫秒来衡量。
每个群集将再次拥有一个且仅有一个领导者，该领导者将一直担任领导者，直到
控制台节点或控制台服务出现故障。

那么，我们的领导者在集群中具体做些什么呢？
领导者节点负责摄取新的日志条目，也就是我们提到的集群键值更新和所有日志条目。只有领导节点才能写入新的日志条目。
这也意味着，领导节点负责处理控制台集群的所有查询和事务。
一旦这些事务得到处理，所有日志条目都已提交，领导节点
负责将所有日志复制到所有跟随节点。

因此，如果我们有一个 5 节点的集群，那么该集群中就只有一个领导节点。
一旦这些日志条目被提交，该单个领导节点就会负责将这些日志复制到五个节点集群中的其他四个跟随节点。
该领导者还负责根据整个集群中的复制和共识来决定何时将条目视为已提交。

现在，说到追随者，追随者除了向领导者转发这些 RPC
转发这些 RPC 请求给领导者，以便从领导者那里写入接受复制的日志，当然，还可以通过投票参与领导者选举。

### Consensus Protocol – Leader Election

<img src="C:\Users\ForceCS\AppData\Roaming\Typora\typora-user-images\image-20240508115505796.png" alt="image-20240508115505796" style="zoom:50%;" />

因此，领导者都是基于随机选举超时。
当一个集群有一个领导者时，该领导者会向所有跟随者节点频繁发送心跳信号。
这样，它们就知道领导者仍然可以继续工作。

现在，每个节点都有一个随机分配的超时时间，大约在 150 到 300 毫秒之间。
举例来说，如果一个节点在随机超时前没有收到领导者的心跳，那么跟随者就会认为领导者已经死了、并进行选举。节点会将自己的状态更改为候选。
它将为自己投一票，并向其他追随者发出投票请求。以获得多数票。
请记住，随机超时在这里至关重要，因为我们不希望所有节点同时超时
因为这样很可能导致选举失败，无法选出领导者。

因此，让我们以图形的形式来看看它是如何工作的。
我们有五个控制台节点，左边是领导者，右边是追随者。
每个追随者节点都有一个随机超时值。
不过，由于整个集群现在看起来一切正常，所以一切都在顺利进行。很好。
好吧，现在灾难降临了，领导者由于某种原因发生了故障。
由于中间的跟随者超时时间最短，该节点会首先发现领导者发生了故障。
因此，该节点将其状态更改为候选。
现在，该节点将为自己投票，并像其他优秀的政治家一样，要求其他追随者
为自己投票。
其他追随者投票后，该节点就成为了新的领导者。

<img src="C:./img/17.png" alt="17" style="zoom:50%;" />

让我们来看看控制台用户、控制台群集领导者和控制台从属节点之间的关系。
这样你就能清楚地了解在正常的控制台操作过程中，谁在做什么。

好吧，假设我们有一位发布工程师，他们想向控制台推送一些更新的变量。
KV 存储，为重大应用部署做准备。
发布工程师使用 API 与控制台集群建立连接。

在这个例子中，我们的集群有五个节点。
左边是领导节点，右边是其余的跟随节点。
现在，发布工程师将向控制台集群推送所需的更改，其中领导者节点
接受并写入这些更改。洞穴写入实际上发生在领导者节点上，然后领导者节点会将所有更改复制到跟随者节点上。
这样，它们就拥有了我们集群的最新日志条目和数据。

控制台复制在这里进行，而所有后端筏操作都在整个集群上进行。
它实际上只与单个节点交互，而 Raft 则负责确保后续节点也能获得更新的变更。

## Gossip Protocol (Serf)

更深入内容请[参考](https://www.serf.io/docs/commands/index.html)

**Based on Serf**

+ Used cluster wide – including multi-cluster
+ Used by clients and servers

**Responsible for:**

+ 管理群集成员（客户端和服务器）
+ 向群集广播连接失败等信息
+ 实现跨数据中心的可靠快速广播
+  Makes use of two different gossip pools
  + LAN
  + WAN

现在，gossip 协议用于整个环境的集群通信。
这意味着服务器和客户端都将使用 gossip 协议进行通信。
控制台使用的 gossip 协议基于 serf，负责管理集群成员。
这意味着，当一个新客户端加入我们的集群时，它可以很容易地发现谁是参与控制台集群的服务器和客户端。
现在，“闲话 ”允许向参与节点广播消息，以识别连接失败等事件。
比如，某个控制台成员无法使用。

流言蜚语不仅适用于单个数据中心，也就是我们刚才提到的控制台数据中心概念。
但流言蜚语也可以在这些数据中心之间工作，启用这种类型的通信将允许
我们在一个数据中心的客户机可以发现另一个数据中心的客户机，而后者是另一个集群的一部分。

为了管理这一点，gossip 使用了两个不同的 gossip pool，即 LAN gossip pool 和 Wan gossip pool。
希望仅从名称上就能看出，LAN 负责本地通信，Wan 负责跨数据通信。

<img src="C:./img/18.png" alt="18" style="zoom:50%;" />

让我们深入了解一下这两个池。

**LAN Gossip Pool**

局域网流言池包含本地数据中心的所有成员。
请记住，每个单个控制台数据中心都有自己的 LAN 八卦池。
LAN 八卦池允许客户端在不知道服务器 IP 地址的情况下发现服务器。
例如，如果您要将一个新客户加入群集，那么闲话允许您将这个新客户
指向群集中的任何成员，无论是客户端还是服务器。LAN 八卦池能让新客户端自动发现控制台服务器。
局域网闲话池还允许整个控制台集群的成员共同承担故障检测职责，而不是仅仅将责任归咎于控制台服务器。
**这意味着控制台客户端将帮助控制台集群中的其他客户端进行故障检测。**
局域网流言池还能在其所有成员之间进行可靠、快速的事件广播。
希望以上内容能让你更好地了解 LAN 八卦池的作用，以及它对控制台部署的重要性。

**WAN Gossip Pool**

现在，这是一个完全独立、全局唯一的池，所有服务器节点都参与其中。
包括所有联合数据中心的服务器节点。
现在，这个特殊的八卦池允许服务器节点执行来自客户端的跨数据中心请求。

因此，如果你使用的是带有故障转移策略的准备查询，服务器就可以在本地服务恰好被标记为不健康的情况下，向另一个数据中心发出请求。
这样就能轻松处理本地服务故障，同时还能将控制台客户端到健康的服务。
即使该服务恰好位于另一个控制台数据中心。
这样，我们不仅能处理单个服务故障，还能处理整个数据中心的故障。

这为我们提供了一个很好的解决方案，确保我们的所有服务都能始终提供给
控制台客户。

<img src="C:./img/19.png" alt="19" style="zoom:50%;" />

记得我们说过，在每个数据中心，每个数据中心都有自己的 Lan Garza 池。
例如，在 DC 一中，我们的池由所有服务器和客户端节点组成。
现在，在 DC 2 中，我们也有一个 LAN 八卦池，它仅由 DC 2 中的所有服务器和客户端组成。

请注意，这两个八卦池之间没有重叠，它们是完全独立的。
现在，如果我们将这两个控制台集群联合起来，就可以将它们连接起来。
现在我们就有了所谓的 Wan 八卦池，它由两个数据中心的服务器节点组成。
这样，本例中一号数据中心的客户端就能发现并轻松与二号数据中心的注册服务通信。

## Network Traffic and Ports

<img src="C:./img/20.png" alt="20" style="zoom:50%;" />

既然谈到了控制台服务器和客户端之间的协议和通信，以及这种
跨数据中心通信，必然会涉及到一定程度的网络和端口对话、
因此，让我们简要讨论一下控制台集群部署的网络和端口请求。
首先，控制台集群环境中的所有通信都是通过 Http 和 Https 进行的。
这种通信是通过我们为控制台提供的证书以 TLS 方式加密的，encrypted using a gossip key.

现在，我们将围绕确保通信安全展开更多讨论，因为这是本课程后面几个目标的一部分。
说到端口，我们需要关注的端口有很多。
另外，请记住，如果你愿意，所有这些端口都是完全可定制的。
首先，与控制台通信的客户端，即发送 API 请求或访问的客户端和UI 将使用 TCP 8500 与控制台通信。这是其中一个通过 TLS 加密的端口。
因此，当你访问用户界面或向控制台发送 API 请求时，将使用你自己的证书颁发机构提供的证书

接下来的两个是我们刚才提到的 gossip protocol 。
LAN gossip通信将通过 TCP/UDP 8301 进行，这意味着集群中的所有客户端和所有服务器都必须能够通过该端口相互通信。否则，就会出现健康检查等问题，日志中也会充满错误。

现在，Wan gossip pool console使用 TCP/UDP 端口 8302。
现在这个端口需要在两个数据中心之间开放，更具体地说是在每个控制台数据中心的服务器节点之间开放。

下一个端口用于 RPC 转发，使用 TCP 端口 8300。

如果你使用 DNS 进行控制台查询（大多数人都这样做），控制台将默认在 8600 端口监听这些查询。

但请记住，在 Linux 中，任何运行在低于 1024 端口的服务器都需要提升权限、
出于安全考虑，我们不希望给控制台服务账户提供这种权限。
如果你正在转发来自 AWS、Route 53 解析器等其他设备的 DNS 查询，那么你
绝对有能力将 DNS 转发到另一个端口。
因此，你只需编写一条规则，说明任何对控制台的查询，都要发送到控制台节点的
8600 端口，一切就都能完美运行了。
与我合作的大多数客户都会继续在 8600 端口上运行 DNS，他们会根据所使用的技术进行适当的更改

**图解如下**

<img src="C:./img/21.png" alt="21" style="zoom:50%;" />

### Accessing Consul

+ Consul API can be accessed by any machine (assuming network/firewall)
+ Consul CLI can be accessed and configured from any server node
+ UI can be enabled in the configuration file and accessed from anywhere

说到访问控制台，我们该如何访问控制台呢？
我们说过，控制台有一个 API。它有用户界面，也有 CLI，但从哪里访问呢？
如果网络连接允许，你可以从网络上的任何地方访问控制台。
尤其是当我们谈到 API 时。以编程方式访问服务并配置解决方案。

现在，说到 CLI，它可以通过服务器节点访问，而你添加或更改的任何控制台配置
添加或更改的任何控制台配置都无需直接在领导者上完成，因为跟随者会自动
将 RPC 调用转发给领导者。
最后，如果启用了用户界面，还可以从网络上的任何地方访问它，前提是网络允许这种通信。

接口都不应该公开，唯一的例外是我们前面谈到的网状网关。

## Consul High Availability

请[参考](https://developer.hashicorp.com/consul/docs/architecture/consensus)

+ High availability is achieved using clustering
  + HashiCorp recommends 3-5 servers in a Consul cluster
  + Uses the Consensus protocol to establish a cluster leader
  + If a leader becomes unavailable, a new leader is elected

+ General recommendation is to not exceed (7) server nodes
  + Consul generates a lot of traffic for replication
  +  More than 7 servers may be negatively impacted by the network or negatively impact the network

正如你在之前的多次讨论中看到的，控制台可以而且确实应该被集群化
为我们的组织提供高可用性。
在生产场景中，控制台的运行节点绝对不能少于三个，甚至这也是
这也只是最低限度的部署。
现在，Hashicorp 建议在一个集群中的 3 到 5 台服务器上运行控制台，但我想说明一下。在现实中，应该把 3 或 5 个节点理解为 4 个节点。
节点集群是一种奇怪的配置。
大多数情况下，你会希望在集群中使用奇数个控制台节点。
集群是通过共识协议形成的，也就是木筏。

但如果你已经看过共识协议部分，就应该已经知道了。
现在，在集群中始终有一个领导者。
如果领导者不可用，就会选出一个新的领导者。
据我从 Hashicorp 了解到的情况，他们一般不建议集群的节点总数超过 7 或 9 个。
总数超过 7 或 9 个节点的集群，因为这么多服务器的复制会产生巨大的网络流量。
而这些网络流量可能会对集群的性能产生负面影响。

因此，尽管我说过通常情况下，我们应该在集群中使用奇数个节点，但一个集群
六个节点是最理想的。
如果你在公共云提供商上部署控制台，并使用三个可用区。
在这种情况下，你会在每个可用区部署两个节点，并使用冗余区。
区（这实际上是一项企业功能），你可以在每个 AZ 中只部署一个有投票权的成员，而另一个则是没有投票权的成员。因此，通过使用这种策略，就投票成员的数量而言，你实际上拥有了一个三节点集群。


如果其中任何一个有投票权的成员宕机，同一 AZ 中的无投票权成员将自动
晋升为有投票权的成员。
现在，这样就能确保仍有三个投票成员，但这些成员仍分散在我们的故障区，或者在这种情况下，可用性区。尽管图表上写着，你只能失去两个，但实际上这只适用于你
不使用冗余区和无投票权成员。
如果你只是建立了一个六节点集群，而没有考虑控制台的冗余区功能、
这个图表是绝对适用的，而且你仍然拥有与五节点集群相同的容错能力。
因此，除非使用控制台的冗余区，否则我绝不会部署六节点集群。
如果你使用冗余区，你可以有效地失去这六个节点中的四个，但你仍然可以拥有一个正常运行的集群。

图表中的最后一种是七节点集群，对于生产性工作负载。
在这种情况下，你的容错能力提高到了三个，但现在你还必须管理该集群中的两个额外节点，这对生产工作负载来说是个不错的选择。

## Scaling for Performance

+ Consul Enterprise supports Enhanced Read Scalability with Read Replicas
  + Scale your cluster to include read replicas to scale reads
  + Read replicas participate in cluster replication 
  + They do NOT take part in quorum election operations (non-voting)

现在，谈到企业功能，让我们来看看一些真正的企业功能。
第一个功能是在控制台中使用读取副本增强读取可扩展性。
这样，我们就可以让正常的控制台集群负责控制台的日常运行。
现在我们可以做的是，当我们组织中的读取数量增加时，我们发现我们也需要
为了处理所有这些额外的读取，我们可以开始使用增强的
读取可扩展性。
我们可以开始部署额外的读副本，作为集群的一部分。
这样，我们就可以扩展集群，将读副本包括在内，从而扩展这些读，对吗？
因此，这些读副本会参与集群复制。
但它们只会处理来自客户端的读取请求。
这样一来，**我们的领导节点就不用替我们处理这些请求了。**

现在，这些读取副本不参与法定人数选举过程，因为它们是无投票权的
成员。

<img src="C:./img/23.png" alt="23" style="zoom:50%;" />

因此，这里有一点需要注意。
让我们来看看这看起来像什么。通常，我们会有三个节点的控制台集群，对吗？
这些是正常的控制台集群成员。
它们是有投票权的成员，每天为我们的客户处理读写操作。
现在，当我们需要扩大集群规模时，我们可以开始添加额外的读取副本，而这些
复制可以帮助我们再次扩大集群规模，而且我们可以引导只读客户端仅指向
指向我们的读副本。
同样，随着我们组织中读取数量的增加，也许我们会在控制台中添加额外的用例。
现在，这些读取副本也是无投票权的成员，因此它们不参与选举过程。
同样，它们只处理读操作。

最后但并非最不重要的一点是，请记住所有服务器节点仍参与群集复制。
这样一来，如果任何一个粉红色的节点，也就是正常的读写节点，获得了任何新数据、它们仍会将数据复制到这里的无投票权成员或读取副本。
这样，如果应用程序需要访问这些读取副本，它们仍能获得最新信息。

## Voting vs. Non-Voting Servers

+ Consul servers can be provisioned to provide read scalability
+ Non-voting do not participate in the raft quorum (voting)
+ Generally used in conjunction with redundancy zones

**Configured using:**

+ non_voting_member setting in the config file
+ the –non-voting-member flag using the CLI

在 Consul 架构中，服务器分为两种类型：Voting Servers 和 Non-Voting Servers。它们在维护集群状态和确保可用性方面发挥着不同的作用。

**Voting Servers:**

- **参与 Raft Quorum:** Voting Servers 是参与 Raft 共识算法的核心节点，它们对集群领导者选举和事务提交进行投票。
- **维护集群状态:** 这些服务器存储 Consul 集群的完整状态，包括键值对、服务注册信息、ACL 规则等。
- **数量有限:** 为了保证性能和效率，Voting Servers 的数量通常较少，推荐配置为 3 个或 5 个。
- **高可用性:** Voting Servers 需要具备高可用性，因为它们的故障可能导致集群不可用。

**Non-Voting Servers:**

- **不参与 Raft Quorum:** Non-Voting Servers 不参与 Raft 共识算法，因此它们不会对领导者选举和事务提交进行投票。
- **缓存集群状态:** 这些服务器缓存来自 Voting Servers 的集群状态信息，可以响应客户端的查询请求。
- **水平扩展:** Non-Voting Servers 可以根据需要进行水平扩展，以提高 Consul 集群的读取性能和吞吐量。
- **故障容忍:** Non-Voting Servers 的故障不会影响集群的可用性，但可能会导致客户端读取到过时的信息。

**使用场景:**

- **Voting Servers:** 用于需要高可用性和数据一致性的场景，例如核心服务注册与发现。
- **Non-Voting Servers:** 用于需要高读取性能和吞吐量的场景，例如大规模服务查询或监控数据收集

## Redundancy Zones

Redundancy Zones (RZs) 在 Consul 中扮演着关键角色，确保服务在面对故障时仍然可用。它们通过将 Consul server 分布到不同的物理或逻辑区域来实现这一点，从而降低单点故障的风险。

**以下是 RZs 的核心概念：**

- **容错能力：** 即使一个 RZ 发生故障，其他 RZ 中的 server 仍然可以继续运作，确保服务的可用性。
- **性能提升：** 将 server 分布到不同的区域可以减少延迟，提升服务性能，特别是在地理位置分散的环境中。
- **灾难恢复：** RZs 在灾难恢复场景中起到至关重要的作用。如果一个区域发生灾难，其他区域的 server 仍然可以提供服务。

**Consul 如何使用 RZs：**

- **Server 分配：** Consul 会自动将 server 分配到不同的 RZs，确保每个 RZ 都有足够的 server 数量来维持 quorum。
- **客户端请求路由：** Consul 客户端会自动将请求路由到其所在 RZ 的 server，从而降低延迟并提高性能。
- **故障检测和恢复：** Consul 会持续监控 server 的状态，并在检测到故障时自动进行故障转移。

同样，我们仍然坚持使用这些企业级功能。
冗余区功能为控制台环境提供了扩展性和恢复性两方面的优势。
每个故障区只部署一个投票成员。
现在，这些故障区可以被识别为类似云提供商中的可用性区，或者
也可能是已架构到企业内部环境中的故障区，也许在这些故障区中
可能为几个不同的故障区定义了一些独立的电源或网络。
无论哪种方式，控制台都能让你根据架构自行识别这些区域。

现在，在每个故障区中，你都部署了多个控制台服务器节点，而每个区中只有一个
是投票成员。
如果这一个有投票权的成员出现故障，同一故障区中的一个无投票权的成员就会被提升为有投票权的成员，以保持故障区的恢复能力。
因此，如果整个可用性区域或内部故障区域发生故障，就意味着你将
该区域的有投票权成员和无投票权成员都将失去。**但是另一个可用去会有两个有投票权的server，以用来解决故障问题**

## Consul Autopilot

Built-in solution to assist with managing Consul nodes

+ Dead Server Cleanup
+ Server Stabilization
+ Redundancy Zone Tags
+ Automated Upgrades

Autopilot is on by default – disable features you don’t want

我个人认为，自动驾驶应该是开源的一部分，因为它能帮助你更轻松地管理集群。
管理集群变得更容易。我觉得自动驾驶仪除了我们刚才谈到的冗余区功能外，还有一些基本功能。
不过，既然规则不是我定的，我们就继续把它作为企业功能集来讨论。
自动驾驶仪是一个内置解决方案，可协助管理我们的控制台节点。

因此，它在这里提供了很多功能，例如死服务器清理、服务器稳定、冗余
区标签和自动升级迁移。
因此，如果你部署了企业二进制文件，自动驾驶仪实际上是默认开启的，而且它有
默认值。
因此，如果你不想使用自动驾驶功能，要么禁用这些功能，要么根据实际情况更新这些不同功能的阈值

让我们快速介绍一下这些功能，以便你了解它们是什么。
首先，让我们快速了解一下这些设置的默认值。
因此，如果运行控制台操作员自动驾驶获取仪表盘配置，就会显示当前配置
所有设置，你可以看到哪些功能已启用或禁用，你还可以看到超时等所有内容。其他设置。
如果你对自动驾驶仪进行了更改，这些更改会在运行此命令时反映出来。
如果需要更改，只需使用控制台操作员 autopilot set config 命令。然后输入参数和所需配置。
因此，在底部的这个示例中，我们将关闭死亡服务器清理功能，将其设置为false。

```shell
$ consul operator autopilot get-config
CleanupDeadServers = true
LastContactThreshold = 200ms
MaxTrailingLogs = 250
MinQuorum = 0
ServerStabilizationTime = 10s
RedundancyZoneTag = ""
DisableUpgradeMigration = false
UpgradeVersionTag = ""
$ consul operator autopilot set-config -cleanup-dead-servers=false
```

### Dead Server Cleanup

+ Dead server cleanup will remove failed servers from the cluster once the replacement comes online based on configurable threshold

+ Cleanup will also be initialized anytime a new server joins the cluster

+ Previously, it would take 72 hours to reap a failed server or it had to be done manually using consul force-leave. 

我们要讨论的自动驾驶的第一个功能就是死服务器清理。
没错，它的功能和听起来差不多。
一旦替代服务器上线，该功能就会根据可配置的阈值，自动将故障服务器从集群中移除。
因此，如果你意外丢失了一个控制台节点，也就是说它没有优雅地离开群集，然后
然后你又部署了一个新的节点来替代它，它就会强行从群集中移除那个死亡的服务器。
当你运行控制台成员命令时，它不会显示为集群节点，而是报告为失败。
因此，当有新服务器加入群集时，也会启动这种清理。
现在，虽然这对控制台集群来说不是什么大问题，但以前控制台需要长达
72 小时才能将故障服务器从集群中移除，或者你必须使用命令行或 API
或使用命令行或 API 强制删除。
Hashicorp 建议您保持启用此功能，以减少从对等集中手动删除旧服务器的需要。

### Server Stabilization

+ New Consul server nodes must be healthy for x amount of time before being promoted to a full, voting member.
+ Configurable time – default is 10 seconds 

Consul 企业版提供了一项名为 **Server Stabilization** 的功能，旨在增强 Consul 集群在面对故障和网络分区时的稳定性。它主要通过以下两个方面实现：

**1. 优雅的领导者过渡 (Graceful Leader Transitions):**

- 在正常情况下，当 Consul 集群的领导者节点发生故障时，会触发新的领导者选举。这个过程通常会导致短暂的服务中断，因为新的领导者需要时间同步状态并接管工作。
- Server Stabilization 功能通过在领导者节点上维护一个 **热备领导者 (Hot Standby Leader)** 来解决这个问题。热备领导者与主领导者保持状态同步，并在主领导者故障时立即接管，从而最大限度地减少服务中断时间。

**2. 增强型 Read Scalability:**

- 在大型 Consul 集群中，大量的读取请求可能会导致性能瓶颈。
- Server Stabilization 允许将 **非领导者服务器 (Non-Leader Servers)** 用于处理读取请求。这有助于分散读取负载，并提高集群的整体读取性能。

### Redundancy Zone Tags

<img src="C:./img/24.png" alt="24" style="zoom:50%;" />

在 Consul 企业版中，Redundancy Zone Tags 是一项强大的功能，用于提高服务的可用性和容错能力。它们允许您根据地理位置或其他因素将节点分配到不同的区域，并确保服务在多个区域中均有副本，从而在出现故障时保持服务的连续性。

**Redundancy Zone Tags 的工作原理：**

1. **定义区域标签：** 您可以为数据中心或可用区等不同区域创建标签，例如 "us-east-1" 或 "eu-west-2"。
2. **分配节点标签：** 将相应的区域标签分配给 Consul 集群中的节点。
3. **服务配置：** 在服务定义中，您可以指定所需的副本数量和区域标签。Consul 将确保在具有匹配标签的不同区域中运行指定数量的服务实例。

**Redundancy Zone Tags 的优势：**

- **提高可用性：** 通过在多个区域中运行服务副本，即使某个区域出现故障，服务仍然可以继续运行。
- **容错能力：** Redundancy Zone Tags 允许您根据特定的故障场景调整服务配置，例如，您可以指定需要在不同机架或可用区中运行的服务实例，以避免单点故障。
- **灵活性和可扩展性：** 您可以根据需要轻松添加或删除区域，并调整服务配置以适应不断变化的需求。

## Automated Upgrades Migrations

这项功能的作用是帮助你管理集群中哪些服务器节点在升级过程中被授予投票权。
因此，当你添加运行较新版本控制台代理的新控制台节点时，控制台会
不会立即将这些新服务器提升为投票成员。
现在，控制台会一直这样处理新节点，直到新节点的数量（即运行的
新版本控制台的节点数等于旧版本控制台的服务器节点数。）
一旦出现这种情况，控制台将提升所有新版控制台服务器的投票权限
并删除旧版本节点的投票权限。
这样，我们就能轻松地将这些旧服务器从群集中移除，而不会对法定人数和群集领导力造成负面影响。

# Deploy a Single Datacenter

**Objective 2a:** Start and manage the Consul process

**Objective 2b: **Interpret a Consul agent configuration

**Objective 2c:**1 Configure Consul network addresses and ports

**Objective 2d:** Describe and configure agent join and leave behaviors

## Consul Agent Configuration

+ Key Options in a **SERVER** configuration file:

  + server (boolean) – is this a server agent or not?

  + datacenter (string)– what datacenter to join

  + node (string) – unique name of agent (usually server name)

  + join/retry_join/auto-join (string) – what other servers/cluster to join

    **1. join:**

    - `join` 用于指定一个或多个现有的 Consul 代理地址，新节点将尝试加入这些地址所在的集群。
    - 这是一个一次性操作，如果加入失败，节点不会自动重试。
    - 适用于手动配置节点加入集群的场景，例如在启动时通过脚本指定要加入的节点。

    **2. retry_join:**

    - `retry_join` 与 `join` 类似，但也包含了重试机制。
    - 如果初始加入尝试失败，节点会定期尝试重新加入，直到成功为止。
    - 适用于需要更强容错性的场景，例如在云环境中节点可能出现短暂的网络问题。

    **3. auto_join:**

    - `auto_join` 提供了更自动化的节点发现和加入机制。
    - 它支持多种发现机制，例如：
      - **cloud auto-join**: 通过云提供商的 API 自动发现并加入集群中的节点。
      - **consul-dns**: 通过 Consul 的 DNS 接口发现并加入集群中的节点。
    - 适用于动态环境，节点数量和位置可能发生变化的场景。

    ```
    { 
    "bootstrap": false, 
    "bootstrap_expect": 3, 
    "server": true, 
    "retry_join": ["10.0.10.34", "10.0.11.72“] 
    }
    
    ```

  + client_addr/bind_addr/advertise_addr (string) – what IP/interface to use for Consul communications

    **1. client_addr**

    - **功能:** 指定 Consul 代理监听客户端连接的地址和端口。客户端（例如：应用程序）通过这个地址与 Consul 代理进行通信，以注册服务、查询服务信息等等。
    - **默认值:** `127.0.0.1:8500`
    - **用途:** 通常情况下，无需修改此项，除非你有特殊的网络配置需求，比如代理运行在容器中并需要通过特定端口暴露服务。

    **2. bind_addr**

    - **功能:** 指定 Consul 代理绑定并监听所有网络接口的地址。此地址用于集群内部的节点间通信，例如：Gossip 协议、RPC 调用等。
    - **默认值:** `0.0.0.0` (监听所有可用接口)
    - **用途:** 在多网卡环境下，可以设置此项来指定 Consul 使用特定的网络接口进行集群内部通信。

    **3. advertise_addr**

    - **功能:** 指定向集群中其他节点通告的地址。其他节点会使用这个地址来连接到该节点。
    - **默认值:** 与 `bind_addr` 相同
    - **用途:** 当 Consul 代理运行在 NAT 网络环境中，或者拥有多个网络接口时，需要设置此项以确保其他节点能够通过正确的地址连接到它。

  + log_level (string) – level of logging (trace, debug, info, etc)

  + encrypt (string) – secret to use for encryption of Consul traffic (gossip)

    **`encrypt` 选项的作用：**

    - **启用 Gossip 通信加密：** 将 `encrypt` 设置为一个 base64 编码的 32 字节密钥，即可启用 Gossip 加密。所有加入 Consul 集群的节点都需要配置相同的密钥才能进行通信。
    - **保护集群安全：** 加密后的 Gossip 消息可以防止未经授权的访问和数据泄露。这对于保护敏感信息（例如 ACL token、KV 存储数据等）至关重要。
    - **提高集群可靠性：** 通过防止恶意节点注入虚假信息，加密可以提高 Consul 集群的可靠性和稳定性。

    **配置 `encrypt` 选项：**

    你需要在所有 Consul 节点的配置文件中设置 `encrypt` 选项。推荐使用 Consul CLI 命令 `consul keygen` 生成一个安全的密钥：

    ```
    $ consul keygen
    ... generated key: <base64-encoded-key>
    ```

    将生成的密钥复制到所有节点配置文件的 `encrypt` 选项中：

    ```
    {
      "encrypt": "<base64-encoded-key>",
      ...
    }
    ```

  + data-dir (string) – provide a persistent directory for the agent to store state

## Configure Networking and Ports

请[参考](https://developer.hashicorp.com/consul/tutorials/archive/dns-forwarding)

<img src="C:./img/25.png" alt="25" style="zoom:50%;" />

## Adding/Removing Consul Agents to the Cluster

详细介绍请[参考](https://developer.hashicorp.com/consul/docs/install/cloud-auto-join)

# Register Service and Use Service Discovery

Objective 3a: Interpret a service registration

Objective 3b: Differentiate ways to register a single service

Objective 3c: Interpret a service configuration with health check 

Objective 3d: Check the service catalog status from the output of the DNS/API interface or via Consul UI

Objective 3e: Interpret a prepared query

Objective 3f: Use a prepared query

## Registering a Consul Service

How do I register a service in Consul?

+ Register with the local agent using:
  + Service Definition File
  + HTTP API

Service Registration typically happens when a new service is provisioned

+ Container is scheduled by Kubernetes
  + Instance is deployed via Terraform
  + Jenkins provisions new VMs on a VMware cluster

Register with the Consul API

+ Method: PUT

+ Endpoint: /v1/agent/service/register

  ```
  $ curl \
  --request PUT \
  --data @payload.json \
  https://consul.example.com:8500/v1/agent/service/register
  ```

  转化为下列的内容

  ```json
  $ cat payload.json
  { 
    "service": {
      "name": "retail-web", 
      "port": 8080
    }
  }
  ```

Register with a service definition

+ Define a service using a service definition file
  + hcl
  + json

Multiple options to register the service using a service definition:

1. Create a single file and set using the **–config-file** parameter

2. Place file inside of the **–config-dir** directory <read at startup>

3. Run the `consul services register` command using file

4. Execute a `consul reload` command after adding file

<img src="C:./img/26.png" alt="26" style="zoom:50%;" />

好了，让我们来看看这看起来像什么。
左边是控制台服务器，右边是三个网络应用程序。在这个例子中，这三个网络应用程序提供的是完全相同的网络服务。我们部署了多个网络应用程序，因为我们需要该应用程序的高可用性和冗余性。现在，为了让所有三个控制台客户端都能在控制台注册相同的服务，每个容器或虚拟机，或运行此网络应用的任何设备，都需要一个服务定义、而服务定义中的某些参数很可能是独一无二的。不过，它们在服务名称、端口和其他参数方面非常相似。因此，如果你要登录这些网络应用程序之一，并打开一个终端，然后说控制台服务注册并指向该服务定义，网络应用程序就会在控制台注册新服务，并可能获得流量。如果有任何针对该特定服务的请求，它就会从控制台获取流量

### Creating a Service Definition

那么，我们该如何创建服务定义呢？它看起来像什么？
这个服务定义也是一个文件，它定义了要在控制台中注册的服务。
一旦服务注册成功，该服务就会作为可用服务添加到控制台服务注册表中。
你可以看到，当我说 “可用服务 ”时，我在这里打了星号。如果你定义了任何健康检查，那么前提是这些检查都通过了。因此，如果它们没有通过，那么它们将不可用。
但如果你没有提供健康检查，或者你的健康检查是通过的，那么该服务
将显示为可用服务，并可接收来自环境中其他节点的流量。
现在，在这个服务定义文件中，可以包含多个参数来定义服务本身，对吗？

+ Service Name

+ ID of the agent

+ Tags

+ IP Address and Port of the service

+  Health Checks

  现在，这些健康检查将允许控制台代理以各种不同的方式查询应用程序，并确定应用程序是否正常运行。

```json
services {
  id = "web-server-01"  #必须是唯一的
  name = "redis"        #遵循DNS标准
  tags = [
    "v7.0","proc"
  ]
  address = "xxxx"
  port = 6000
  checks = [
    {
      args = ["/bin/check_redis", "-p", "6000"]
      interval = "5s"
      timeout = "20s"
    }
  ]
}
services {
  id = "web-server-02"
  name = "redis"
  tags = [
    "delayed",
    "secondary"
  ]
  address = ""
  port = 7000
  checks = [
    {
      args = ["/bin/check_redis", "-p", "7000"]
      interval = "30s"
      timeout = "60s"
    }
  ]
}
```

如果不在服务定义中指定地址，它将只使用控制台代理的 IP 地址。
现在，当你注册一项服务时，从 DNS 的角度来看，它将有一个默认的命名空间。
大多数人会使用默认的控制台名称，但实际上可以在配置文件中进行更改。
如果我们向控制台发送该 DNS 名称的 DNS 查询，就会返回提供该前端电子商务服务的节点。在这种情况下，我们只有一个节点，IP 地址是 xxx。因此，如果我们现在查询 DNS 这个主机名，就会返回这个 IP 地址。
同样，服务定义文件中的每个 ID 都应该是唯一的。
Web 服务器一、Web 服务器二、Web 服务器三，不管你怎么称呼你的容器、你的虚拟机、你的实例、因此，当目录中有多个节点提供相同服务时，我们完全可以这样做。
这为我们提供了高可用性和弹性，高可用性是因为我们的环境中有多个节点提供相同的服务。

因此，如果其中一个节点出现故障，控制台就会向其他健康的服务发送请求。
现在，它还提供了弹性，因为当我们收到更多请求时，我们可以轻松扩展，前提是我们的应用程序支持。
当请求越来越少时，我们就可以缩小规模。

因此，换句话说，如果我是一个应用程序，我进入控制台说，嘿，我正在寻找这个前端.如果我有十个服务，只有在控制台成功注册并通过健康检查的注册服务才会返回控制台。我们有控制台和六个不同的搜索服务实例，从搜索一到搜索六。
例如，每个容器都在 Kubernetes 中进行了调度，然后在 console 中注册为托管搜索服务。
控制台注册为托管搜索服务。
但现在，其中一些节点可能无法正常运行，也许在搜索一上，服务
无法正常运行。
因此，我们可以看到有两个节点没有通过健康检查。
因此，如果有应用程序向搜索服务控制台发送 API 请求，控制台只会
返回给我们四个健康的节点

### **Configuring a Service Health Check**

![27](C:./img/27.png)

## Check Service Status from the Catalog

Multiple ways to determine the status of services

1. DNS Query – most commonly used

2. API Request – requires app integration

3. Consul UI – least commonly used

### DNS Query

<img src="C:./img/28.png" alt="28" style="zoom:50%;" />

Java 应用、微服务将发出传统的 DNS 请求。它可能会说，我需要数据库服务控制台。
现在，这个 Java 微服务可能已经有了为其分配的默认 DNS 服务器，就像我们组织内的所有其他节点通常都会指向基于数据中心或云服务提供商的集中式 DNS 服务器。
现在，在这个 DNS 服务器中，我们很可能会为控制台域创建一个 DNS 转发器。
我们的意思是，如果有任何关于控制台的请求，就将这些请求发送到控制台集群，对吗？它会将请求转发到控制台。所以它会说："嘿，酷，我知道谁正在托管数据库服务控制台，所以它会返回健康的节点。然后 DNS 会用从控制台获取的健康节点响应我们 Java 应用微服务的 DNS 查询。现在，微服务将使用 DNS 查询返回的其中一个 IP 地址，以建立与数据库的连接。

<img src="C:./img/29.png" alt="29" style="zoom:50%;" />

让我们来看看 DNS 查询是什么样的。
在 Linux 上的这个示例中，我搜索了控制台服务器，发现端口是 8600。我们说过控制台使用的端口之一是8600 用于 DNS。因此，我们对 8600 端口进行挖掘，寻找前端电子商务服务控制台。因此，你可以看到 DNS 客户端找到了一个服务器。
然后在底部的黄色区域，你可以看到可用服务的 IP 地址。
在这个例子中，只有一个节点为我们提供前端电子商务服务。
因此，如果我们有一个应用程序查询控制台，这就是我们会得到的 IP 地址

```
root@docker-agent:/etc/apt#  

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> @12.0.0.40 -p 8600 front-end-eCommerce.service.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16159
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;front-end-eCommerce.service.consul. IN	A

;; ANSWER SECTION:
front-end-eCommerce.service.consul. 0 IN A	12.0.0.60

;; Query time: 4 msec
;; SERVER: 12.0.0.40#8600(12.0.0.40) (UDP)
;; WHEN: Thu May 16 10:58:45 CST 2024
;; MSG SIZE  rcvd: 79

```



### API Request

<img src="C:./img/30.png" alt="30" style="zoom:50%;" />

让我们来谈谈 API 请求和它的工作原理。
我们有 Java 应用程序。微服务同样需要与我们的数据库服务器通信。
同样，在这种情况下，Java 应用程序的微服务是控制台感知的。换句话说，微服务可以直接向控制台发出 API 请求。
它可以说："嘿，我正在服务目录中寻找这个特定的服务，控制台是这样的、酷，我知道谁在托管数据库服务。给你，Java 应用先生。

<img src="C:./img/31.png" alt="31" style="zoom:50%;" />

```
curl --request GET "http://12.0.0.40:8500/v1/catalog/service/front-end-eCommerce?ns=default" 
```

## 关于预查询的介绍

+ 允许您创建和注册更复杂的服务查询，以便稍后执行
  + 允许比仅 DNS 更丰富的查询
  + 用于过滤服务请求结果
  + Objects defined at the datacenter level

+ Created by using the /query API endpoint
+ Consumed by either API or DNS query
  + <name>.query.consul
+ 当多个数据中心联合起来时，我们可以扩展准备好的查询，以返回其他数据中心的服务
  + Extension of Prepared Queries
  + Transparent to Applications
  + Determines Target for a Service Request

在此之前，我们只能使用 DNS 名称来查询控制台，对吗？我们可以说，嘿，我们只想要前端电子商务服务控制台，它就会说，嘿，酷、我知道是谁在托管它。我把它还给你。但也许我们有多个节点托管该服务，而我们只想要返回特定的节点。也许我们只想要最新版本或旧版本。这样，我们就能提供比 DNS 更丰富的查询。

准备查询可用于过滤服务请求和准备的结果。查询实际上只是在每个数据中心级别定义的对象。因此，如果我们有多个联合在一起的数据中心，那么每个数据中心都有准备查询。要创建准备查询，我们可以使用斜线查询 API 端点，然后我们可以使用 API 或 DNS 来使用准备查询。

让我们通过这个例子来真正理解准备查询的作用。

打个比方，我们有一个用户需要一辆新车。也许他们的车坏了，也许他们没有车，等等。于是，他们来到控制台经销商处，而控制台经销商就会说，嘿，我们有所有这些
不同的汽车或车辆。你会说，酷，太棒了。但你知道，我有特定的需求，我有特定的请求。我需要汽车，不需要卡车。所以我们现在只剩三辆车了。就像，你知道，它也必须是红色的，对不对？我不想要旧车。

<img src="C:./img/32.png" alt="32" style="zoom:50%;" />

### **Types of Failover Policies**

<img src="C:./img/33.png" alt="33" style="zoom:50%;" />

**Static Policy**

所以我们说，嘿，如果本地失败了，就去试两个，然后按照这个顺序去试三个。这是一个固定列表

**Dynamic Policy**

如果本地失败，就会根据往返时间将其发送到最近的数据中心。因此，控制台能够确定该节点与所有其他已注册服务和其他数据中心之间的往返时间。服务和其他数据中心之间的往返时间。然后，它将确定最短的往返时间，并将该节点返回给请求。

**Hybrid Policy**

上边两种的结合

### **EXAMPLE**

```
root@mattermost:/etc/consul.d# curl --request POST --data  @prepared-query.json  http://12.0.0.50:8500/v1/query   |jq  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   157  100    45  100   112   2553   6356 --:--:-- --:--:-- --:--:--  9235
{
  "ID": "4ca9956a-569a-fa12-2df3-c6421b850e3a"
}
root@mattermost:/etc/consul.d# curl   http://12.0.0.50:8500/v1/query/4ca9956a-569a-fa12-2df3-c6421b850e3a    |jq    
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   471  100   471    0     0  47958      0 --:--:-- --:--:-- --:--:-- 52333
[
  {
    "ID": "4ca9956a-569a-fa12-2df3-c6421b850e3a",
    "Name": "Commerce",
    "Session": "",
    "Token": "",
    "Template": {
      "Type": "",
      "Regexp": "",
      "RemoveEmptyTags": false
    },
    "Service": {
      "Service": "front-end-eCommerce",
      "SamenessGroup": "",
      "Failover": {
        "NearestN": 0,
        "Datacenters": null,
        "Targets": null
      },
      "OnlyPassing": false,
      "IgnoreCheckIDs": null,
      "Near": "",
      "Tags": [
        "v7.05",
        "production"
      ],
      "NodeMeta": null,
      "ServiceMeta": null,
      "Connect": false,
      "Peer": ""
    },
    "DNS": {
      "TTL": ""
    },
    "CreateIndex": 47091,
    "ModifyIndex": 47091
  }
]
root@docker-agent:~# dig @12.0.0.40 -p 8600 Commerce.query.consul  

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> @12.0.0.40 -p 8600 Commerce.query.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23201
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;Commerce.query.consul.		IN	A

;; ANSWER SECTION:
Commerce.query.consul.	0	IN	A	12.0.0.60

;; Query time: 0 msec
;; SERVER: 12.0.0.40#8600(12.0.0.40) (UDP)
;; WHEN: Thu May 16 12:28:29 CST 2024
;; MSG SIZE  rcvd: 66

```

现在假设这个文件更新了，我们可以先获取之前的ID ,然后使用Put

```
root@docker-agent:~# curl -s http://12.0.0.40:8500/v1/query | jq -r '.[] | select(.Name == "Commerce").ID'
4ca9956a-569a-fa12-2df3-c6421b850e3a
root@docker-agent:~# #curl --request PUT --data @/root/new_prepared_query.json http://12.0.0.40:8500/v1/query/0816d77a-301d-206f-0e27-266f79b6e555

```

# Access the consul Key/Value

Objective 4a: Understand the capabilities and limitations of the KV store

Objective 4b: Interact with the KV store using both the Consul CLI and UI

Objective 4c: Monitor KV changes using watch

Objective 4d: Monitor KV changes using envconsul and consul-template

## **What is the Key/Value Store?**

控制台键值存储为我们提供了一个集中式键值存储，允许我们的用户存储任何类型的对象。现在，控制台键值存储遵循分布式架构，因为我们遵循这种分布式架构。
数据在我们所有的服务器节点上进行复制。这包括有投票权的成员、无投票权的成员以及我们之前提到的读取副本。
现在，这为我们提供了完全冗余，因为如果我们的控制台集群中丢失了一个或多个节点,我们的数据仍会复制到所有剩余节点上。
现在，这个键值存储已安装在控制台中，并且始终处于启用状态，因此你可以随时使用它。我们可以将任何类型的对象放入其中，没有任何限制。

现在，它不会是一个数据库，也不能存储文件或类似的东西。但同样，它是一个键值存储空间。我们可以在这里输入键和键值。控制台存储常用于存储配置参数和相关元数据。因此，当我们的应用程序首次启动时，他们可以访问控制台存储并提取一些部署应用程序所需的配置参数。

如果控制台洞穴的用户拥有适当的 ACL 令牌，则可以使用它。

既然我们知道了键值存储是什么，那我们就来谈谈它不是什么。
因此，键值存储并不像 DynamoDB 那样是一个功能齐全的数据库，尽管它也有一些类似的功能。键值存储不是加密的键值存储。控制台不会对你添加到洞穴存储中的数据进行加密。因此，你应该只存储非敏感数据。如果是敏感数据，则应使用类似 Vault 这样的工具。现在，洞穴存储没有目录结构，尽管它支持使用正向
斜线来组织数据。现在，正斜线作为路径的一部分，会像其他字符一样被处理。
因此，举例来说，我们这里有 Cave Forward slash app 一个斜线密钥或网络 API 访问。
正如我提到的，它总是在单个数据中心内的节点间复制，即在集群内的服务器节点间复制。但数据不会跨数据中心复制。
关于控制台存储，还有几件事。
它有对象大小限制，每个对象为 512 KB。
如果你过去使用过 Vault，并将控制台作为后端，也有同样的限制。

### **Designing the K/V Structure**

+ Design your K/V structure before you start using it
  + Sit down with your peers (remote works as well) and outline what the K/V structure will look like
  + Align the design to your application and infrastructure teams and operational use cases

+ Every K/V structure will be different, and it should be designed  for the current and future use cases

<img src="C:./img/34.png" alt="34" style="zoom:50%;" />

## **Accessing the Key/Value Store**

<img src="C:./img/35.png" alt="35" style="zoom:50%;" />

**HTTP API **

<img src="C:./img/36.png" alt="36" style="zoom:50%;" />

<img src="C:./img/37.png" alt="37" style="zoom:50%;" />

**Command-Line Interface (CLI)**

<img src="C:./img/38.png" alt="38" style="zoom:50%;" />

## **Monitor KV Changes Using Watch**

请[参考](https://developer.hashicorp.com/consul/docs/dynamic-app-config/watches)

既然我们已经在键值存储中存储了数据，那么如何监控变化呢？我们有多种方法可以做到这一点。我们有控制台监视。控制台监视为我们提供了一种监控控制台内部特定变化的方法。
一旦数据视图更新，就会调用特定的处理程序。因此，你可以调用一个处理程序，也可以直接将其日志记录下来。然后，你可以通过一些日志收集软件来使用这些日志。

现在，我提到的处理程序可以做两种不同的事情。
有两种不同类型的处理程序。
第一种是，只要检测到变化，我们就可以使用某个 shell 调用命令。
例如，如果我们检测到控制台中的某个键发生了更改，我们可以让它运行一个脚本
也许该脚本可以更新某个应用程序，或做出我们需要的其他更改。

另一个处理程序是，我们可以让控制台访问一个 Http 端点。
现在，这很可能会告诉控制台访问某种 API，而我们要向该 API 提供一些信息，以便做某件事或通知应用程序某件事发生了变化。因此，watch 会再次监控变化。

现在，控制台中启用了不同类型的监视。比如，我们可以使用 key 来观察特定的键值对。例如，之前我们有 API 密钥及其值，如果它发生变化，我们可以调用脚本来更新应用程序以使用新的密钥。
我们有一个密钥前缀，因此我们可以观察洞穴存储中的密钥前缀，观察可用服务列表，并对此采取行动。观察集群内的节点列表。观察服务实例，观察健康检查的值，或者观察自定义用户事件。

<img src="C:./img/39.png" alt="39" style="zoom:50%;" />

<img src="C:./img/40.png" alt="40" style="zoom:50%;" />

**Configuring a Watch**

+ 在 Consul API 中使用blocking queries实现监控
+ 可将监视添加到agent configuration中，使其在代理启动后运行…
+  …或使用 Consul watch 命令在代理之外启动它
+ 即使只有一个条目发生变化，Consul 也会返回查询的所有匹配条目

## Using envconsul

+ Envconsul 启动一个子进程，根据从 Consul（和 Vault！）获取的数据设置环境变量。

+ 在应用程序服务器（Consul 客户端）上运行的独立二进制文件

+ envconsul 填充环境变量，应用程序读取环境变量
  + 应用程序不再需要以明文方式读取包含敏感数据的配置文件
  + 从 KV 或 Consul 服务中检索数据
+ 允许在应用程序不知道使用 Consul 获取值的情况下简化应用程序集成

更多信息请[参考](https://github.com/hashicorp/envconsul)

envconsul 是一个简单的工具，它允许你从 HashiCorp Consul 中获取配置并将它们加载到你的应用程序环境变量中。它使用 Consul 的 Key-Value 存储来存储配置数据，并将这些数据解析为环境变量，使你的应用程序能够访问它们。

**主要优点:**

- **简化配置管理:** 不再需要手动更新配置文件，所有配置数据都存储在 Consul 中，可以轻松管理和更新。
- **集中化管理:** 所有应用的配置信息都集中存储在 Consul 中，方便维护和管理。
- **动态更新:** 当配置更新时，envconsul 会自动将新的环境变量加载到应用程序中，无需重启应用。

<img src="C:./img/42.png" alt="42" style="zoom:50%;" />

<img src="C:./img/43.png" alt="43" style="zoom:50%;" />

### 实验

[下载地址](https://releases.hashicorp.com/envconsul/0.13.2/)

我们在之前的consul k/v中put一些数据，如下

```
consul kv put apps/eCommerce/database_host customer_db
consul kv put apps/eCommerce/database billing
consul kv put apps/eCommerce/connection_string <data> 
```

可以使用envconsul获取其中的值，并设置为环境变量

```
(客户端)root@mattermost:~/envconsul# envconsul   -upcase  -prefix   apps/eCommerce     env 
```

## Consul Template

+ consul-template 将 Consul 中的值填充到运行 consul-template 守护进程的文件系统中

+ 在应用服务器（Consul 客户端）上运行的独立二进制文件

+ 使用预先配置的模板文件作为输入

+ 输出带有从 Consul 中填充的数据的文件 

<img src="C:./img/45.png" alt="45" style="zoom:50%;" />

**1. 模块化和可复用性:**

- 将每个服务或应用程序的配置模板分离成独立的文件，方便管理和维护。
- 使用模板变量和函数来提高代码的可复用性，减少重复代码。
- 创建通用的模板片段，可用于不同的配置场景。

**2. 安全性和容错机制:**

- 使用 `consul-template` 的 `-retry` 选项，确保在 Consul 连接失败时，自动重试连接。
- 限制模板中使用的 `{{ .Data }}` 数据的范围，防止意外更改敏感信息。
- 使用 `consul-template` 的 `-once` 选项，确保模板只执行一次，避免重复写入配置。

**3. 可读性和易维护性:**

- 使用注释和清晰的变量名称来提高模板代码的可读性。
- 采用一致的代码风格，例如缩进、命名规范等，提高代码维护效率。
- 避免过度使用嵌套结构，保持模板结构简洁清晰。

**4. 与其他工具集成:**

- 将 `consul-template` 与其他工具集成，例如 Ansible、Terraform 等，实现更强大的自动化配置管理。
- 利用 `consul-template` 的 `-notify` 选项，在配置更新后，自动通知其他工具执行相关操作。

**5. 测试和监控:**

- 定期测试 `consul-template` 模板，确保其能正常工作。
- 使用监控工具，监控 `consul-template` 的运行状态，及时发现问题并进行处理。

例子

**场景:** 想要根据 Consul 中的配置，更新 Web 服务器的配置。

**Consul 数据:**

```json
{
  "web": {
    "port": 8080,
    "host": "127.0.0.1",
    "path": "/api"
  }
}
```

**模板文件:**

```
server {
  listen {{ .Data.web.port }};
  server_name {{ .Data.web.host }};

  location {{ .Data.web.path }} {
    # ... 配置代码
  }
}
```

**命令:**

```bash
consul-template -template "web.conf.tmpl" -config "web.conf"
```

该命令将从 Consul 中获取 `web` 配置，并将它应用到 `web.conf.tmpl` 模板中，生成 `web.conf` 文件，并更新到 Web 服务器。

### 实验 

**Using Consul-Template to monitor Changes to Consul K/V**

```
root@mattermost:/etc/consul.d# cat config.json.tpl 
environment: {{ key "apps/ecommerce/environment" }}
version: {{ key "apps/ecommerce/version" }}
root@mattermost:/etc/consul.d# consul-template -template "config.json.tpl:./config.json" -once     
root@mattermost:/etc/consul.d# cat config.json
environment: production
version: 4.5

```

# Back Up and Restore

Objective 5a: Describe the Contents of a Snapshot

Objective 5b: Back Up and Restore the Datacenter

Objective 5c: [Enterprise] Describe the Benefits of Snapshot Agent Features

## Introduction to Consul Snapshots

Consul snapshots are point-in-time snapshots of the Consul state  (raft)

+ A snapshot is the primary backup and DR solution for Consul
+ Snapshots create a gzipped tar archive that includes (but not limited to):
  + Key/Value entries
  + Service catalog
  + Prepared queries
  + Sessions
  + ACLs

By default, snapshots are taken in consistent mode, meaning  that the leader performs the snapshot

+ The leader validates whether it is the leader first
+ A follower can take the snapshot if the –stale flag is used
  + Useful to reduce the load on a leader but could lose data
  + Also useful if a cluster does not have a leader

## Using Consul Snapshots

### **Back up the Consul Datacenter**

+ Snapshots can be taken using the API or CLI
+ They can be created manually or can be automated by an external process(jenkins等)…
+ …or by using the Consul Snapshot Agent (Enterprise)
+ Requires a valid ACL token to perform

+ Manual snapshots could be taken before:
  + Consul upgrades – provides a way to fail back
  + Bootstrap a new identical datacenter with the same name

**Back up and Restore using the CLI**

The consul snapshot command

+ agent (Ent) – run the snapshot agent as a long-running daemon
+ inspect – view metadata about an existing snapshot file
+ restore – restore the referenced snapshot to Consul
+ save – create a new Consul snapshot

![46](C:./img/46.png)

**Back up using the API**

Create snapshots using the API

+ Method: GET
+ Endpoint: /snapshot

<img src="C:./img/47.png" alt="47" style="zoom:50%;" />

请记住，如果您在群集上启用了 ACL，那么快照命令，无论是通过 API、CLI 还是控制台快照代理，它们都需要一个有效的 ACL 标记才能执行快照。但我们只需知道，任何这些命令都需要一个有效的 ACL 令牌,而该令牌需要与赋予它适当权限的策略绑定。

现在，这些情况可能发生在控制台升级之前。比如说，你想把控制台从 1.9 升级到 1.9.1。这样，如果在升级过程中出了问题，我们就有办法退回。现在，我们可能要手动拍摄快照的另一个原因是，如果我们要启动一个新的完全相同的数据中心启动到一个全新的群集。

因此，举例来说，如果我们想建立一个新的群集，可能是在一个隔离的网络中进行测试或类似的操作，我们可以采取手动快照的方式.类似的情况，我们可以给这个群集拍摄快照，然后将其还原到另一个群集

```
root@mattermost:/etc/consul.d# consul  snapshot save  consul.snap  
Saved and verified snapshot to index 96051
root@mattermost:/etc/consul.d# ls
config.json  config.json.tpl  consul.env  consul.hcl  consul.snap  prepared-query.json  service-with-health.hcl
root@mattermost:/etc/consul.d# consul  snapshot inspect    consul.snap  
 ID           507-96051-1716174304295
 Size         15896
 Index        96051
 Term         507
 Version      1

 Type                        Count      Size
 ----                        ----       ----
 Register                    13         9.8KB
 ConnectCA                   1          1.2KB
 ConnectCAProviderState      1          1.1KB
 Index                       27         904B
 CoordinateBatchUpdate       4          693B
 PreparedQuery               2          691B
 KVS                         4          414B
 Autopilot                   1          199B
 ConnectCAConfig             1          195B
 SystemMetadata              3          191B
 FederationState             1          143B
 ChunkingState               1          12B
 ----                        ----       ----
 Total                                  15.5KB

```



### **Restore the Consul Datacenter**

+ Restoring Consul from a snapshot is usually done when recovering from a disaster recovery scenario
  + Example: Restoring to a fresh set of Consul servers
+ A restore is a disruptive process, and it is an “all or nothing” type of action
  + You cannot selectively restore data
+ Restoring Consul is also not designed to handle a server failure during  the restore process

**Restore using the API**

<img src="C:./img/48.png" alt="48" style="zoom:50%;" />

## Consul Snapshot Agent (Enterprise)

**长期运行的守护进程，定期拍摄 Consul 集群快照**

+ 可定制的时间间隔（快照拍摄频率）

+ 可定制的时间间隔（快照拍摄频率）
+ Retention configuration (how many snapshots should we keep)
+ Multiple options to store snapshots:
  + Local filesystem
  + S3-Compatible storage (Amazon S3 or other)
  + Azure Blob Storage
  + Google Cloud Storage

**Benefits of using the Consul Snapshot Agent:**

+ Automated snapshots of the Consul cluster

+ Manages its own leadership election for high availability
+ Provides failover in the event the leader becomes unavailable
+ Run the agent across all servers but only get one consistent snapshot per interval
+ Registers itself as a Consul service
  + Easy to keep track of status and health using API, UI, or CLI
  + Health checks can alert you of problems so you can take action

**Configuration**

<img src="C:./img/49.png" alt="49" style="zoom:50%;" />

<img src="C:./img/50.png" alt="50" style="zoom: 50%;" />

有关更多信息请[参考](https://github.com/btkrausen/hashicorp/blob/master/consul/consulsnapshots.service)

# Register a Service Proxy

+ Objective 6a: Understand Consul Connect service mesh high level architecture
+ Objective 6b: Describe configuration for registering a proxy
+ Objective 6c: Describe intentions for Consul Connect service mesh
+ Objective 6d: Check intentions in both the Consul CLI and UI

**Hashicorp Consul 的 Service Mesh 功能详解**

Hachicorp Consul 提供了一套丰富的功能来实现和管理 Service Mesh，主要体现在以下几个方面：

**1. 服务发现与注册:**

- **自动注册/取消注册:** Consul Agent 可以自动将服务注册到 Consul 集群，并在服务终止时自动取消注册。
- **健康检查:** Consul 支持多种健康检查机制，确保只有健康的服務实例可以被发现。
- **多种服务发现方式:** Consul 提供 DNS 和 HTTP API 两种方式供服务发现和查询。

**2. 流量管理:**

- **流量路由:** Consul 可以根据服务版本、请求头、权重等条件进行流量路由。
- **金丝雀部署:** 支持将流量逐步迁移到新版本服务，方便进行灰度发布和 A/B 测试。
- **故障注入:** 可以模拟服务延迟和错误，测试服务的容错能力。

**3. 安全性:**

- **mTLS 加密:** Consul 支持服务间通信的双向 TLS 加密，增强安全性。
- **访问控制:** 通过 Intentions 控制服务间的访问权限，限制访问范围。
- **证书管理:** Consul 可以自动生成、分发和更新证书，简化证书管理。

**4. 可观测性:**

- **指标收集:** Consul 收集服务指标，例如请求延迟、错误率等，帮助监控服务运行状态。
- **分布式追踪:** 集成第三方工具，实现分布式追踪，方便定位问题。
- **日志聚合:** Consul 可以收集和转发服务日志，便于分析和排查故障。

**5. 与其他工具集成:**

- **Kubernetes:** Consul 可以作为 Kubernetes 的服务发现和配置中心。
- **Prometheus:** 集成 Prometheus 进行指标监控和告警。
- **Jaeger:** 集成 Jaeger 实现分布式追踪。

**Consul Service Mesh 的优势:**

- **易于使用:** Consul 提供简单易用的 API 和工具，方便部署和管理 Service Mesh。
- **功能丰富:** Consul 提供了服务发现、流量管理、安全性和可观测性等全面的功能。
- **与其他工具集成:** Consul 可以与 Kubernetes、Prometheus、Jaeger 等工具集成，构建完整的微服务架构。

**一些需要注意的方面:**

- **性能:** Consul Service Mesh 的性能取决于部署规模和配置，需要进行测试和优化。
- **复杂性:** 随着服务规模的增长，Consul Service Mesh 的配置和管理会变得复杂。

**总结:**

Consul 提供了一套功能强大的工具和 API，可以帮助您构建和管理 Service Mesh。 它的易用性、丰富的功能和与其他工具的集成使其成为构建微服务架构的理想选择。

## Introduction to Consul Service Mesh

Provides service-to-service connection authorization and encryption

+ Uses mTLS for authorization and encryption
+ Applications can be written for native support using SDK or…
+  …use a sidecar proxy architecture (most common)

Applications may or may not be aware that Consul service mesh is present

+ Traffic between apps flow through the sidecar proxy
+ The proxy enables authenticated and encrypted communication (mTLS) between services
+ Could provide encryption between services that wouldn't otherwise be encrypted

### 更详细的说明

Certificate Authority issues mTLS certificates

+ mTLS is the core of Consul Service Mesh
+ Consul has a built-in certificate authority that can be used
+ Has support to "outsource" CA functionality to HashiCorp Vault or other solutions

mTLS Certificates

+ Provides authentication by validating the certificate against the CA
+ Enables encryption between the services

Intentions define access control for Services

+ Determines what services can establish connections to other services
+ Top-down ruleset using Allow or Deny intentions
+ Can be configured via API, CLI, or UI

Sidecar Proxy

+ ervice proxy running alongside the core application
+ Primary sidecar proxy used today is Envoy (envoyproxy.io)
+ onsul also has a built-in sidecar proxy (but not as feature-rich)
+ Other proxies can be used as well

Service Mesh is platform agnostic

+ Manage services running on physical networks, public cloud, software-defined networks, or even cross-cloud

Service Mesh enables Layer 7 observability

+ Proxies see all traffic between services and can collect metrics
+ Metrics can be sent to an external monitoring tool, like Prometheus

Connect must be enabled in the agent configuration (connect stanza)

+ Connect is enabled by default if using –dev mode

Upstream vs. Downstream

+ <img src="C:./img/51.png" alt="51" style="zoom:50%;" />

### **Consul Service Mesh - High-Level Architecture**

<img src="C:./img/52.png" alt="52" style="zoom: 33%;" />

<img src="C:./img/53.png" alt="53" style="zoom:33%;" />

### **Consul Service Mesh – Other Components**

L7 Traffic Management

+ "Carve up" traffic across the pool of services vs. just using round robin

+ Sometimes called traffic splitting

Service Mesh Gateways

+ Enables routing between federated service mesh datacenters where private connectivity may not be established or feasible

+ Ingress gateways and terminating gateways(k8s)

Observability

+ Consul 1.9.0 includes new topology visualizations to show a service's connectivity

## Register a Service Proxy

请参考[1](https://developer.hashicorp.com/consul/docs/connect/proxies/envoy)

再说一遍，服务代理其实就是我们的 sidecar 代理的另一个名称，它将与我们的应用程序一起运行。因此，就像我们在控制台中使用的任何服务一样，sidecar 代理也必须在控制台中注册。这样，控制台就能知道在连接服务时要使用哪个 sidecar 代理。

在控制台注册服务代理时，并不会启动 sidecar 代理。请记住，sidecar 代理是与应用程序并行运行的另一个服务，它将要由你来启动 sidecar 代理服务。
因此，这可能是一个控制台连接代理，也可能是运行在应用程序旁边的类似 envoy 的服务。

请记住这里有两个不同的任务。向控制台注册 sidecar 代理，然后启动 sidecar 代理，让服务启动并运行。现在，当我们注册服务代理时，我们几乎总是使用配置文件来完成。我们也可以通过 API 来完成，但我们要讨论的是如何通过配置文件来完成。配置文件通常与服务本身的配置文件相同。因此，当我们在控制台注册一个新服务时，我们还将在配置文件中包含关于我们的 sidecar服务的信息。

<img src="C:./img/54.png" alt="54" style="zoom: 50%;" />

##  Intro to Consul Service Mesh Intentions

Intentions define access control for Services

+ Uses a service graph to determine what services are allowed to establish connections to other services

+ Enforced at the destination/target service on inbound connections, proxy requests, or within a natively integrated app (SDK)

Enforcing Intentions

+ Default behavior is controlled by the default ACL policy
+ 'Allow all' default means all connections are allowed by default
+ 'Deny all' default means all connections are denied by default
+ Only one intention controls authorization at any given time

Consul Service Mesh Intentions Controlling Authorization

+ Authorization is control using either L4 or L7 depending on the protocol being used

  + L4 – identity based (TLS) – all or nothing access control based on new connections
  + L7 – application-aware – can be based on L7 request attributes based on new requests

  **Consul Service Mesh Intentions 控制授权详解**

  **1. L4 授权 (基于身份, TLS):**

  - **工作原理:** L4 授权基于 TLS 身份验证。当服务尝试建立连接时，Consul 会检查连接双方的身份证书。如果证书有效且符合配置的策略，则允许连接；否则，连接将被拒绝。

  - 特点:

    - **全有或全无:** L4 授权是一种粗粒度的控制方式，它只能允许或拒绝整个连接，而不能控制连接建立后传输的具体数据。
    - **基于身份:** 授权决策基于连接双方的身份，而不是请求的内容。

  - 适用场景:

     

    L4 授权适用于需要简单、高效的访问控制场景，例如：

    - 限制只有特定服务可以访问数据库。
    - 阻止来自未知 IP 地址的连接。

  **示例:**

  假设我们有一个 Web 服务和一个数据库服务。我们希望只有 Web 服务可以访问数据库。

  我们可以使用 L4 授权来实现这个目标。首先，我们需要为 Web 服务和数据库服务配置 TLS 证书。然后，我们可以创建一个 Intention，指定只有来自 Web 服务的连接才能访问数据库服务。

  **2. L7 授权 (应用感知):**

  - **工作原理:** L7 授权可以检查应用层协议的请求内容，例如 HTTP headers, cookies, paths 等。Consul 可以根据这些信息进行更细粒度的授权控制。

  - 特点:

    - **细粒度控制:** L7 授权可以根据请求的具体内容进行授权，例如允许访问特定路径或资源。
    - **应用感知:** 授权决策可以基于应用层的信息，例如用户角色、请求方法等。

  - 适用场景:

     

    L7 授权适用于需要更复杂、灵活的访问控制场景，例如：

    - 允许特定用户访问特定资源。
    - 根据请求参数限制访问速率。
    - 阻止访问包含恶意内容的请求。

  **示例:**

  假设我们有一个 API 网关，它接收来自不同用户的请求。我们希望只允许付费用户访问特定的 API 接口。

  我们可以使用 L7 授权来实现这个目标。首先，我们需要配置 API 网关，使其将用户信息添加到请求头中。然后，我们可以创建一个 Intention，指定只有包含付费用户标识的请求才能访问特定的 API 接口。

  **总结:**

  L4 授权和 L7 授权各有优缺点，选择哪种方式取决于具体的应用场景。

  - 如果需要简单、高效的访问控制，可以选择 L4 授权。
  - 如果需要更复杂、灵活的访问控制，可以选择 L7 授权。



既然我们已经对 sidecar 代理和所有其他组件有了更多了解，那就让我们开始讨论 intentions ，因为它是控制台服务网格中非常重要的一部分。
在入站连接中，代理请求或如果我们有一个本地集成的应用程序
现在，当我们执行意图时，默认行为由我们在控制台中创建的默认 ACL 策略控制。
如果我们有一个名为 allow 的默认策略，那么这意味着所有连接都将被默认允许除非我们特别设置了拒绝意图。
如果我们的默认策略是 deny all，则意味着默认情况下拒绝所有连接，我们必须必须使用允许意图明确允许不同服务之间的连接。

<img src="C:./img/56.png" alt="56" style="zoom: 33%;" />

所有这些服务都在服务目录中进行了注册，这些服务可以通过服务目录相互通信。
因此，当我们开始创建意图时，就可以开始构建我们的服务图，而我们要做的第一件事就是
我们可以说，嘿，也许我们想让网络应用程序与平台 API 通信。也许这是我们的网络应用程序需要执行的核心功能。因此，我们创建了我们的意图，网络应用程序可以成功地与平台 API 服务通信。
现在，也许我们允许搜索服务与数据库服务通信，这样搜索服务就可以请求与数据库服务通信。

请记住，因为我们使用的是控制台，所以我们使用的是基于身份的授权，而不是像 IP 地址那样的授权。
因此，当我们的单个服务扩展或缩减时，无论有多少副本或迭代,这个特定应用程序的副本或迭代次数并不重要。

同样，它可能是 Kubernetes 调度的一堆容器，也可能是 Jenkins 或其他自动化工具启动的虚拟机，因为它们将自己注册为网络应用程序。
这个网络应用程序的任何副本都能访问平台 API，因为意图允许这样做。现在，右下方的库存也是一样，不管有多少个不同的,库存服务都会被拒绝与身份服务通信。与身份服务进行通信。

## Managing Consul Service Mesh Intentions

<img src="C:./img/57.png" alt="57" style="zoom: 33%;" />

<img src="C:./img/58.png" alt="58" style="zoom: 33%;" />

<img src="C:./img/59.png" alt="59" style="zoom:33%;" />

## 实验-Service Mesh

请[参考](https://developer.hashicorp.com/consul/tutorials/get-started-vms/virtual-machine-gs-service-mesh?in=consul%2Fdeveloper-mesh)

```
root@docker-agent:/etc/consul.d# ls
consul.env  consul.hcl	count.hcl  service.json
root@docker-agent:/etc/consul.d# cat count.hcl 
node_name = "counting"

service {
  name = "counting"
  id   = "counting-1"
  port = 9003
 
  connect {
    sidecar_service {}
  }

  check {
    id          = "counting-check"
    http        = "http://localhost:9003/health"
    method      = "GET"
    interval    = "1s"
    timeout     = "1s"
  }
}
root@docker-agent:/etc/consul.d# consul   services register count.hcl 
Registered service: counting

root@docker-agent:/etc/consul.d# cat dashboard.hcl 
node_name = "dashboard"

service {
  name = "dashboard"
  port = 9002
 
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "counting"
            local_bind_port  = 5000
          }
        ]
      }
    }
  }

  check {
    id          = "dashboard-check"
    http        = "http://localhost:9002/health"
    method      = "GET"
    interval    = "1s"
    timeout     = "1s"
  }
}
root@docker-agent:/etc/consul.d# consul   services register  dashboard.hcl 
Registered service: dashboard


root@docker-agent:/etc/consul.d# cat intention-config.hcl
Kind = "service-intentions"
Name = "counting"
Sources = [
  {
    Name   = "dashboard"
    Action = "allow"
  }
]
root@docker-agent:/etc/consul.d# consul config write intention-config.hcl 
Config entry written: service-intentions/counting

```

# Secure Agent Communication

Objective 7a: Understanding Consul security/threat model

Objective 7b: 区别 TLS 加密所需的证书类型

Objective 7c: 了解不同的 TLS 加密设置，实现完全安全的数据中心

## Consul Security/Threat Model

所涉及到的安全模块如下：

Gossip Protocol Encryption

+ Gossip protocol can encrypt communications throughout the cluster

Built-In ACL System

+ ACL system protects data and APIs

Consul Agent Communication

+ Consul agent supports encrypting all communications using TLS (RPC/API)

mTLS for Authenticity + Encryption

+ mTLS are used to verify authenticity and encrypt communications

Certificate Authority

+ Consul can act as a CA, or natively integrate with an existing CA (Vault or other)

详细解释如下

Gossip Protocol (Serf)
- Gossip protocol 使用对称密钥
- 本质上是集群中服务器和客户端的 “共享密钥 ”方法

ACL System

+ Optional system – not enabled by default
+ 保护对 Consul 数据和 HTTP API 的访问

Consul Agent

+ 支持 TLS 证书，为 RPC 和 API 连接的通信加密
+ 允许在不受信任的网络（公共云、互联网等）上运行 Consul
+  在服务器配置文件中启用
+ Consul 可验证incoming/outgoing通信并检查服务器主机名

Certificate Authority

+ Consul can act as a CA to issue certificates for the datacenter
+ Certificate types include:
  + Server - consul tls cert create –server (CLI command)
  +  Client – consul tls cert create –client (CLI command)
  + CLI – consul tls cert create –cli (CLI command)

mTLS to Validate Authenticity and Encrypt Communications

+ Uses the CA to validate authenticity against public CA bundle

+ Used for Service Mesh functionality

## Certificates Required in Consul

Consul HTTP API and RPC communication require TLS certs

+ Encryption

Service Mesh connectivity uses mTLS certificates

+ Authenticity
+ Encryption

**如果要手动配置应用程序接口使用 HTTPS，可在 Consul 上手动设置 HTTP 端口（-https-port）并提供证书**

Consul can act as the CA

+ Enabled if connect is enabled without specifying a CA provider

+ Consul can automatically distribute client certificates (automated)

+ Or you can do it manually

Certificates can be generated from your own CA

+ You must distribute certs manually, also known as the 'operator' method



► Certificates must be signed by the same Certificate Authority

► You can update to a new provider at any time

## TLS Encryption Settings

请[参考](https://developer.hashicorp.com/consul/docs/security/encryption#rpc-encryption-with-tls)

现在，当我们要使用控制台 TLS 配置时，存在三种主要配置

+ verify_server_hostname

  + 所有outgoing connections均执行主机名验证
  + Ensures that servers have a certificate valid for server.<datacenter>.<domain>
  + Ensures a client cannot modify the Consul Agent config and restart as a server
  + Without this setting, Consul only verifies that the cert is signed by a trusted CA

  <img src="C:./img/60.png" alt="60" style="zoom:50%;" />

  **为什么需要验证服务器主机名？**

  在 TLS 握手过程中，服务器会向客户端提供其数字证书。该证书包含服务器的主机名信息。如果未启用主机名验证，攻击者可以拦截客户端和服务器之间的通信，并提供伪造的证书，其中包含攻击者控制的主机名。客户端如果未验证主机名，就会信任该伪造证书，从而建立与攻击者的连接，泄露敏感信息。

  **验证服务器主机名参数的作用**

  启用 `verify_server_hostname` 参数后，Consul 客户端会在 TLS 握手期间执行以下操作：

  1. **提取证书中的主机名：** 从服务器提供的数字证书中提取主机名信息。
  2. **比较主机名：** 将提取的主机名与客户端配置的目标主机名进行比较。
  3. **验证结果：** 如果两个主机名匹配，则连接建立成功。如果不匹配，则连接将被拒绝，防止与潜在的恶意服务器通信。

  **示例**

  假设您要连接到主机名为 `consul.example.com` 的 Consul 服务器。在客户端配置中，您需要将 `verify_server_hostname` 设置为 `true`，并将目标主机名设置为 `consul.example.com`。

  ```
  {
    "verify_server_hostname": true,
    "address": "consul.example.com:8501"
  }
  ```

+ verify_incoming

  `verify_incoming`选项决定了Consul服务器和代理在接受客户端连接时是否验证客户端的证书。这是双向TLS（mTLS）的一部分，确保通信的双方都经过验证。

  #### 启用`verify_incoming`

  当`verify_incoming`设置为`true`时，Consul服务器和代理在接受客户端连接时会进行以下验证：

  1. **证书链验证**：验证客户端证书是否由受信任的CA（证书颁发机构）签署。受信任的CA列表通过`ca_file`或`ca_path`指定。
  2. **证书有效期验证**：检查客户端证书的有效期，确保证书在当前时间是有效的。
  3. **证书吊销状态验证**：如果启用了CRL（证书吊销列表）或OCSP（在线证书状态协议）检查，会验证客户端证书是否被吊销。
  4. **主机名验证**：检查证书中的主机名是否与客户端的实际主机名匹配（可选项，根据配置决定）。

  配置示例：

  ```
  json复制代码{
    "verify_incoming": true,
    "ca_file": "/path/to/ca-certificates.crt",
    "cert_file": "/path/to/server-cert.crt",
    "key_file": "/path/to/server-key.key"
  }
  ```

  在上述配置中，Consul服务器或代理会使用指定的CA证书文件来验证连接客户端的证书。

+ verify_outgoing

  原理是和verify_incoming

# Secure Services with Access  Control Lists (ACLs)

Objective 8a: Set up and configure a basic ACL system

Objective 8b: Create Policies

Objective 8c: Manage token lifecycle: multiple policies, token revoking, ACL roles, service identities

Objective 8d: Perform a CLI request using a token

Objective 8e: Perform an API request using a token

## Introduction to the Consul ACL System

如果你启用了控制台 ACL 系统并对其进行了正确配置，那么基本上你想在控制台做的任何事情，都必须向它提供适当的令牌才能完成。

现在，控制台 ACL 系统依赖于令牌，而这些令牌与策略相关联。这些策略定义了访问权限，也就是说，这些策略将决定我们在控制台中的权限。
现在，控制台 ACL 系统的关键组件包括令牌，而令牌正是你所想的那样。
这是一个承载令牌，在我们向控制台发送任何请求时都会用到。无论我们使用的是 UI、CLI 还是 API。
如果我们启用了控制台 ACL 系统，并且配置正确，那么基本上在控制台做任何事情都需要一个令牌。才能在控制台中执行任何操作。

现在，要创建一个令牌，令牌要附加到策略上，而策略就像其他策略一样。它是一组规则，将决定应用于实际令牌的细粒度规则。简而言之，就是我们希望令牌在控制台中拥有的权限。
所以，我希望你能读取这个洞穴存储。我希望你能读取某个服务。我希望你能执行这个准备查询。我们可以在策略中配置所有这些不同的规则。

我们还有角色。角色其实就是一组策略和服务 identity，可以应用到一堆令牌上。对不对？
我们还有服务身份。服务身份是一种策略模板，可以将策略与令牌或角色联系起来。当我们使用服务网状结构功能、控制台连接时，这些功能才是真正有用的、对不对？
这就是我们使用服务身份的目的。

<img src="C:./img/61.png" alt="61" style="zoom:50%;" />

**Service Identities**

+ An ACL policy template that links a policy for services in Service Mesh (connect)

+ Helps avoid boilerplate policy creation since similar policies tend to look identical when you have many services registered and using the Service mesh feature

+ Helps services/sidecars to be discovered and easy discover other services

+ Can be used on tokens and roles

+ Applies preconfigured ACL rules

**Service Identities are composed of:**

+ Service – the name of the service (and possibly sidecar proxy)

+ Datacenters – a [list] of datacenter(s) that policy is valid for

**Roles**

+ A named set of policies and service identities
+ Sort of a "grouping" of multiple policies & service identities that can be assigned to many tokens

**Roles are composed of the following elements:**

+ ID – auto generated identifier

+ Name – unique name within Consul

+ Description – human readable description

+ Policy Set – a [list] of policies you want to apply to the role

+ Service Identities – a [list] of service identities for the role

<img src="C:./img/62.png" alt="62" style="zoom:50%;" />

## **What are Policies?**

<img src="C:./img/63.png" alt="63" style="zoom:50%;" />

<img src="C:./img/64.png" alt="64" style="zoom:50%;" />

### **ACL Resources Available for Rules**

<img src="C:./img/65.png" alt="65" style="zoom:33%;" />

因此，如果你要建立一个新节点，无论是服务器还是客户端，并希望客户端能在控制台注册，就需要一定程度的节点权限。

查询（Query）等功能将围绕准备查询（prepare query）操作展开。我们前不久讨论过准备查询，但如果你希望客户端能够执行准备查询.准备查询，他们可能需要对所有准备查询或某些准备查询的读取权限。

这里还有服务，这是一个相当重要的问题。些是服务级目录操作。因此，如果你要注册我们之前谈到的电子商务前端网站，你将需要权限。您需要读取或写入权限，具体取决于您要做什么。因此，如果你要注册一个名为电子商务前端的新服务，你就需要对该特定服务拥有写权限。

### **Creating Policies**

<img src="C:./img/66.png" alt="66" style="zoom:33%;" />

<img src="C:./img/67.png" alt="67" style="zoom:33%;" />

<img src="C:./img/68.png" alt="68" style="zoom:33%;" />

**Policy for the Anonymous Token**

<img src="C:./img/69.png" alt="69" style="zoom: 33%;" />

## **Core Components of Consul ACLs**

Tokens

+ Bearer token used during the UI, CLI, or API request (assuming default deny)
+ Tokens are created and attached to a policy
+ Used to determine if the request is authorized to perform the request action

Basic components of a token include:

+ Accessor – the name or ID of the token
+ Secret ID – the actual token used during a request
+ Policy Set – the policy or policies attached to the token
+ Description – human readable description of the token

### **Default ACL Tokens**

Bootstrap/Master Token

+ Bootstrap Token has unrestricted privileges (linked to Global-Management Policy)
+ Initial method of authentication for ACL configuration after bootstrapping
+ Bootstrap token should NOT be used on a day-to-day basis and securely protected
+ If the bootstrap token is lost, there is a "reset" to recreate one
+ SecretID will be unique

Anonymous Token

+ Used when a request is made that does not specify a bearer token
+ Cannot delete the token but you can update the description and privileges
+ Commonly set to read services (DNS/API) for unauthenticated clients (possibly more)
+ ID is always 00000000-0000-0000-0000-000000000002

# Use Gossip Encryption

**Objective 9a:** Understanding the Consul security/threat model

**Objective 9b:** Configure gossip encryption for the existing data center

**Objective 9c:** Manage the lifecycle of encryption keys

## **Gossip Encryption**

<img src="C:./img/19.png" alt="19" style="zoom:50%;" />

因此，流言协议再次使用对称密钥进行加密。因此，对于集群中的服务器和客户端来说，这本质上更像是一种共享秘密的方法。现在，当我们创建这个对称密钥时，我们将详细说明，必须在集群中的所有代理中使用相同的密钥。请记住，包括服务器和客户端在内的整个群集都在使用八卦协议。因此，如果它们想参与冲浪流言池，就需要这个密钥来进行身份验证、以便加密和解密整个群集发送的信息。

因此，除了使用相同密钥的同一集群中的代理外，如果你的环境中存在联合数据中心，那么这些联合数据中心也需要使用相同的密钥。

流言密钥是一个 32 字节、64 位编码的密钥，我们使用它进行加密。在整个集群中发送信息时，我们都将使用这个密钥对数据进行加密。
当然，所有客户端或服务器都将使用该密钥来解密所有信息，并能读取。

现在，你可以使用内置工具控制台密钥生成器来生成新的密钥。这就是控制台的内置功能。

## Configure Gossip Encryption

请[参考](https://developer.hashicorp.com/consul/docs/security/encryption)

## Manage the Lifecycle of Encryption Keys





# 附加说明

## 服务端配置

```hcl
log_level  = "INFO"
server     = true
datacenter = "us-east-1"
primary_datacenter = "dc1"

ui_config {
  enabled = true
}

# TLS Configuration
tls {
  default {
    key_file               = "/etc/consul.d/cert.key"
    cert_file              = "/etc/consul.d/client.pem"
    ca_file                = "/etc/consul.d/chain.pem"
    verify_incoming        = true
    verify_outgoing        = true
    verify_server_hostname = true
  }
}

# Gossip Encryption - generate key using consul keygen
encrypt = "pCOEKgL2SYHmDoFJqnolFUTJi7Vy+Qwyry04WIZUupc="

leave_on_terminate = true
data_dir           = "/opt/consul/data"

# Agent Network Configuration
client_addr    = "0.0.0.0"
bind_addr      = "10.0.0.170"
advertise_addr = "10.0.0.170"

# Disable HTTP and use 8501 for HTTPS
ports {
  http  = -1
  https = 8501
}

# 这行配置了 Consul server 集群的预期服务器数量。当启动的服务器数量达到这个数字时，Consul 才能进行 leader 选举并正常运作
bootstrap_expect = 5
retry_join       = ["provider=aws tag_key=Environment-Name tag_value=consul-cluster region=us-east-1"]

# Enable and Configure Consul ACLs
acl = {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"
  tokens = {
    agent = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
}

# Set raft multiplier to lowest value (best performance) - 1 is recommended for Production servers
performance = {
    raft_multiplier = 1
}

# Enables auto encrypt for distribution of certs to Consul clients from the Connect CA
auto_encrypt {
  allow_tls = true
}

# Enable service mesh capability for Consul datacenter
connect = {
  enabled = true
}
```

## 客户端配置

```
{
  "log_level": "INFO",
  "server": false,
  "node_name": "node-a.example.com",
  "key_file": "/etc/consul.d/cert.key",
  "cert_file": "/etc/consul.d/client.pem",
  "ca_file": "/etc/consul.d/chain.pem",
  "verify_incoming": true,
  "verify_outgoing": true,
  "encrypt": "xxxxxxxxxxxxxxxxxxxxxxxx",
  "data_dir": "/opt/consul/data",
  "datacenter": "us-east-1",
  "bind_addr": "10.10.10.10.10",
  "client_addr": "0.0.0.0",
  "retry_join": ["provider=aws tag_key=Environment-Name tag_value=consul-cluster region=us-east-1"],
  "enable_syslog": true,
  "acl": {
     "tokens": {
        "agent": "xxxxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
        }
  }
}
```

## HashiCorp Consul 加入集群配置解析

```
{ 
"bootstrap": false, 
"bootstrap_expect": 3, 
"server": true, 
"retry_join": ["10.0.10.34", "10.0.11.72“] 
}
```

这段 JSON 代码片段定义了 HashiCorp Consul agent 的一些配置参数：

- **bootstrap**: 设置为 `false` 表示该 agent 不是 bootstrap 节点。Bootstrap 节点是 Consul 集群中负责初始化集群并选举 leader 的特殊节点。
- **bootstrap_expect**: 设置为 `3` 表示预期集群中将有 3 个 bootstrap 节点。当实际数量达到预期时，Consul 才会进行 leader 选举。
- **server**: 设置为 `true` 表示该 agent 将作为 server 运行。Server 节点负责维护 Consul 集群的状态，处理请求，并存储数据。
- **retry_join**: 这是一个字符串数组，包含了两个 IP 地址："10.0.10.34" 和 "10.0.11.72"。这些地址是该 agent 将尝试加入的现有 Consul 集群的地址。

总的来说，这段代码片段配置了一个 Consul server 节点，该节点期望加入一个包含 3 个 bootstrap 节点的集群，并提供了两个用于尝试加入集群的地址。

## HashiCorp Consul 中节点加入集群 Cloud Auto-Join 的原理

Consul 的 Cloud Auto-Join 功能允许节点在启动时自动发现并加入 Consul 集群，而无需手动配置集群地址。这对于动态环境（例如云平台）中的节点管理非常方便。

Cloud Auto-Join 利用云平台的元数据服务或 API 来实现自动发现。以下是其工作原理：

**1. 云平台集成:**

- Consul 支持多种云平台，包括 AWS, Azure, GCP, Alibaba Cloud 等。
- 每个云平台都有其特定的元数据服务或 API，例如 AWS 的 EC2 实例元数据服务或 Azure 的实例元数据服务。

**2. 配置 Cloud Auto-Join:**

- 在 Consul agent 配置文件中启用 `cloud_auto_join` 选项。
- 指定云平台和相关的配置参数，例如 region, tag 等。

**3. 节点启动:**

- 当 Consul agent 启动时，它会查询云平台的元数据服务或 API。
- 根据配置参数，它会获取到符合条件的 Consul 服务器地址列表。
- agent 会尝试连接到这些服务器，并加入到 Consul 集群。

**4. 健康检查和维护:**

- Consul 会定期检查节点的健康状况，并维护集群成员列表。
- 如果节点出现故障或离开云平台，它会自动从集群中移除。

**优点:**

- **简化节点管理:** 无需手动配置集群地址，减少人为错误。
- **动态扩展:** 适应云环境中节点的动态变化。
- **高可用性:** 自动发现和加入集群，提高服务可用性。

**限制:**

- 依赖于云平台的元数据服务或 API。
- 需要配置云平台特定的参数。
- 可能需要额外的安全配置，例如 IAM 角色或访问密钥。

**一些常见的云平台集成配置示例：**

- **AWS:** 使用 EC2 标签来识别 Consul 服务器，并通过实例元数据服务获取服务器地址。
- **Azure:** 使用资源组或虚拟网络来识别 Consul 服务器，并通过实例元数据服务获取服务器地址。
- **GCP:** 使用实例标签或项目 ID 来识别 Consul 服务器，并通过 Compute Engine 元数据服务获取服务器地址。

## **如何生成 ACL 令牌**

你可以使用以下几种方法生成 ACL 令牌：

**1. 使用 Consul CLI:**

这是最常见的方法。使用 `consul acl token create` 命令，并指定所需的权限。例如，要创建一个具有全局管理权限的令牌，请运行：

```
consul acl token create -description="Global Management Token" -policy-name=global-management
```

这将输出新创建的令牌的 ID。

**2. 使用 Consul API:**

你也可以使用 Consul API 来创建令牌。例如，以下 curl 命令将创建一个具有全局管理权限的令牌：

```
curl \
  --request PUT \
  --data '{"Description": "Global Management Token", "Policies": [{"Name": "global-management"}]}' \
  http://localhost:8500/v1/acl/token
```

**3. 在启动 Consul Agent 时使用配置文件:**

你可以在 Consul Agent 的配置文件中定义 ACL 令牌，并在启动时自动创建它们。例如：

```
acl = {
  enabled = true
  tokens = {
    "global-management" = {
      policy = "global-management"
      description = "Global Management Token"
    }
  }
}
```

**重要注意事项:**

- **安全存储令牌:** 生成的 ACL 令牌非常敏感。确保将它们存储在安全的地方，并且不要与未经授权的人员共享。
- **最小权限原则:** 始终遵循最小权限原则。仅授予用户完成其工作所需的最低权限。
- **定期轮换令牌:** 定期轮换 ACL 令牌是一个良好的安全实践。
