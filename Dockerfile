# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -f Dockerfile -t bnhf/wolweb . --push --no-cache
FROM golang:1.14-alpine AS builder

LABEL org.label-schema.vcs-url="https://github.com/bnhf/wolweb" \
      org.label-schema.url="https://github.com/bnhf/wolweb/blob/master/README.md"

RUN mkdir /wolweb
WORKDIR /wolweb

# Install Dependecies
RUN apk update && apk upgrade && \
    apk add --no-cache git && \
    git clone https://github.com/bnhf/wolweb . && \
    go mod init wolweb && \
    go get -d github.com/gorilla/handlers && \
    go get -d github.com/gorilla/mux && \
    go get -d github.com/ilyakaznacheev/cleanenv

# Build Source Files
RUN go build -o wolweb .

# Create 2nd Stage final image
FROM alpine
WORKDIR /wolweb
COPY --from=builder /wolweb/index.html .
COPY --from=builder /wolweb/wolweb .
COPY --from=builder /wolweb/config.json .
COPY --from=builder /wolweb/static ./static
COPY start.sh /

RUN chmod +x /start.sh

ARG WOLWEBPORT=8089

EXPOSE ${WOLWEBPORT}

CMD ["/start.sh"]
