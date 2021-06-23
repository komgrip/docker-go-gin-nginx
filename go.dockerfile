ARG GO_VERSION=1.16.5

FROM golang:${GO_VERSION}-alpine AS build

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*

RUN mkdir -p /go/src
WORKDIR /go/src

COPY /go/src/go.mod .
COPY /go/src/go.sum .
RUN go mod download

COPY . .
RUN go build -o ./app ./go/src/main.go

FROM alpine:latest

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

RUN mkdir -p /go/src
WORKDIR /go/src
COPY --from=build /go/src/app .
COPY /go/src/.env /go/src

EXPOSE 8000

ENTRYPOINT ["./app"]