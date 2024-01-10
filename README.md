# frp docker

无需手动改配置文件，通过环境变量即可实现内网穿透

仓库地址：[https://github.com/seepine/frp](https://github.com/seepine/frp)

## 一、基本用法

### 1.服务端

```yml
version: '3.7'
services:
  frps:
    image: seepine/frps
    ports:
      # 暴露服务端绑定端口
      - 6666:6666
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
    image: seepine/frpc
    environment:
      SERVER_ADDR: 192.168.100.100
      SERVER_PORT: 6666
      # 当需要代理http时需要配置此变量
      # VHOST_HTTP_PORT: 7777
      TOKEN: yourtoken
      # 通过CLIENTS配置代理，name为必须配置项
      CLIENTS: '{"name":"myServer","type":"tcp","local_ip":"127.0.0.1","local_port":9999,"remote_port":9999}'
```


## 二、进阶用法

### 1.多配置
```yml
version: '3.7'
services:
  frpc:
    image: seepine/frpc
    environment:
      SERVER_ADDR: 192.168.100.100
      SERVER_PORT: 6666
      TOKEN: yourtoken
      # 支持json数组
      CLIENTS: |
        [
          {
            "name":"myServer",
            "type":"tcp",
            "local_ip":"127.0.0.1",
            "local_port":9999,
            "remote_port":9999
          },
          {
            "name":"demoWeb",
            "type":"http",
            "local_ip":"127.0.0.1",
            "local_port":3000,
            "custom_domains":"demo.example.com"
          },
        ]
```

### 2.更多配置写法

[https://gofrp.org/zh-cn/docs/examples/](https://gofrp.org/zh-cn/docs/examples/)

## 三、更多

也可以手动配置 `frps.ini` 和  `frpc.ini` 实现需要的功能，用法和官方一致

然后修改`ENTRYPOINT ["/usr/bin/frps","-c","frps.ini"]`即可