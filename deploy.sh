docker buildx build -t seepine/frpc:v0.44.0 \
   --platform=linux/amd64,linux/arm64 \
   -f ./Dockerfile-frpc . --push

docker buildx build -t seepine/frps:v0.44.0 \
   --platform=linux/amd64,linux/arm64 \
   -f ./Dockerfile-frps . --push