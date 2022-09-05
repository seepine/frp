echo "[common]" >frpc.ini
echo "server_addr = $SERVER_ADDR" >>frpc.ini
echo "server_port = $SERVER_PORT" >>frpc.ini

if [ -n "$TOKEN" ]; then
    echo "token = $TOKEN" >>frpc.ini
fi

fill() {
    hasName=$(echo $1 | jq 'has("name")')
    if [ $hasName = "false" ]; then
        return 1
    fi
    NAME=$(echo $1 | jq -r '.name')
    echo "" >>frpc.ini
    echo "[$NAME]" >>frpc.ini

    KEYS=$(echo $1 | jq 'del(.name)' | jq 'keys')
    for item in ${KEYS[@]}; do
        KEY=$(echo $item | sed 's/\"//g' | sed 's/\,//g')
        if [ $KEY != "[" -a $KEY != "]" ]; then
            VALUE=$(echo $1 | jq .$KEY | sed 's/\"//g')
            echo "$KEY = $VALUE" >>frpc.ini
        fi
    done
    return 0
}
if [ -n "$CLIENTS" ]; then
    if [ ${CLIENTS:0:1} = "[" ]; then
        ARR=$(echo $CLIENTS | jq -c '.[]')
        for item in ${ARR[@]}; do
            fill $item
        done
    else
        fill $CLIENTS
    fi
else
    echo ''
    echo 'not find CLIENTS evn, you can set environment (name is required in object)'
    echo ''
    echo '  CLIENTS="{"name":"ssh","type":"tcp","local_ip":"127.0.0.1","local_port":9999,"remote_port":9999}"'
    echo 'or'
    echo '  CLIENTS="[{"name":"ssh","type":"tcp","local_ip":"127.0.0.1","local_port":9999,"remote_port":9999}]"'
    echo ''
    echo 'it will generate like this'
    echo "[ssh]"
    echo 'type = tcp'
    echo 'local_ip = 127.0.0.1'
    echo 'local_port = 9999'
    echo 'remote_port = 9999'
    echo ''
fi

/usr/bin/frpc  -c frpc.ini
