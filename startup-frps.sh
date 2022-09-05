echo "[common]" > frps.ini
echo "bind_port = $BIND_PORT" >> frps.ini

if [ -n "$BIND_ADDR" ];then
    echo "bind_addr = $BIND_ADDR" >> frps.ini
fi
if [ -n "$VHOST_HTTP_PORT" ];then
    echo "vhost_http_port = $VHOST_HTTP_PORT" >> frps.ini
fi
if [ -n "$BIND_UDP_PORT" ];then
    echo "bind_udp_port = $BIND_UDP_PORT" >> frps.ini
fi
if [ -n "$KCP_BIND_PORT" ];then
    echo "kcp_bind_port = $KCP_BIND_PORT" >> frps.ini
fi

if [ -n "$TOKEN" ];then
    echo "token = $TOKEN" >> frps.ini
fi

/usr/bin/frps  -c frps.ini