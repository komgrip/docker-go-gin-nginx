ARG GO_VERSION=1.16.5

FROM golang:${GO_VERSION}-alpine AS build

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*

RUN mkdir -p /api
WORKDIR /api

COPY /src/go.mod .
COPY /src/go.sum .
RUN go mod download

COPY . .
RUN go build -o ./app ./src/main.go

FROM alpine:latest

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

RUN mkdir -p /api
WORKDIR /api
COPY --from=build /api/app .
COPY /src/.env /api

EXPOSE 8000

ENTRYPOINT ["./app"]