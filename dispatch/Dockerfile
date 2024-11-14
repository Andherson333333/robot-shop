# Etapa de compilación
FROM golang:1.23-alpine AS builder
WORKDIR /go/src/app
COPY main.go .
RUN go mod init dispatch
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o dispatch

# Etapa final
FROM alpine:3.20.3
RUN apk --no-cache add ca-certificates
WORKDIR /go/src/app
COPY --from=builder /go/src/app/dispatch .
CMD ["./dispatch"]
