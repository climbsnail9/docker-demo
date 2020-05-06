# 编译阶段
FROM golang:1.13.10 as builder
# copy 语句要合并，尽量减少图层
COPY main.go  go.mod /build/
WORKDIR /build
RUN GOPROXY=https://goproxy.io go get && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server

# 运行阶段
FROM scratch
# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=builder /build/server /app/

ENTRYPOINT ["/app/server"]
