ARG GO_VERSION=1.16.5

FROM golang:${GO_VERSION}-alpine AS build

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*
RUN mkdir -p /app/go/src
WORKDIR /app/go/src

COPY /go/go.mod .
COPY /go/go.sum .
RUN go mod download

COPY . .
RUN go build -o ./app ./go/main.go

FROM alpine:latest

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN mkdir -p /app/go
WORKDIR /app/go

COPY --from=build /app/go/src/app .
COPY /go/env_developer /app/go/.env

EXPOSE 8000

ENTRYPOINT ["./app"]