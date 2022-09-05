# frp docker

无需手动改配置文件，通过环境变量即可实现内网穿透

仓库地址：[https://github.com/seepine/frp](https://github.com/seepine/frp)

## 一、基本用法
### 1.服务端

```yml
version: '3.7'
services:
  frps:
    image: seepine/frps:v0.44.0
    ports:
      - 7000:7000
      # 暴露客户端需要的端口
      - 9999:9999
    environment:
      # 可修改绑定端口，为空默认7000，另外也支持VHOST_HTTP_PORT，BIND_UDP_PORT，BIND_ADDR，KCP_BIND_PORT等配置
      BIND_PORT: 6666
      # 可配置token，可为空
      TOKEN: yourtoken
```

### 2.客户端

```yml
version: '3.7'
services:
  frpc:
    image: seepine/frpc:v0.44.0
    environment:
      SERVER_ADDR: 192.168.100.100
      SERVER_PORT: 6666
      TOKEN: yourtoken
      # 通过CLIENTS配置代理
      CLIENTS: '{"name":"ssh","type":"tcp","local_ip":"127.0.0.1","local_port":9999,"remote_port":9999}'
```

最终会形成一下配置

```ini
[common]
server_addr = 192.168.100.100
server_port = 6666
token = yourtoken

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 9999
remote_port = 9999
```

## 二、多配置

```yml
version: '3.7'
services:
  frpc:
    image: seepine/frpc:v0.44.0
    environment:
      SERVER_ADDR: 192.168.100.100
      SERVER_PORT: 6666
      TOKEN: yourtoken
      # 支持json数组
      CLIENTS: '[{"name":"ssh","type":"tcp","local_ip":"127.0.0.1","local_port":9999,"remote_port":9999}]'
```

## 三、更多

也可以通过修改 `/hoome/frp/frps.ini` 和  `/hoome/frp/frpc.ini` 实现需要的功能，用法和官方一致