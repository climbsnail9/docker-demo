# 编译阶段
FROM golang:1.13.10 as builder

COPY main.go /build/
COPY go.mod /build/

WORKDIR /build
RUN GOPROXY=https://goproxy.io go get
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server

# 运行阶段
FROM scratch
MAINTAINER Razil "john_yxh@163.com"
# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=builder /build/server /app/

# PORT
#EXPOSE 8080
#EXPOSE 22

ENTRYPOINT ["/app/server"]
