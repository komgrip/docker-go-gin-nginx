ARG GO_VERSION=1.16.5
ARG PORT=8000

FROM golang:${GO_VERSION}-alpine AS build

RUN apk --no-cache add gcc g++ make git
WORKDIR /go/src/app

COPY /go .
RUN go mod init itraffic
RUN go mod tidy
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/web-app ./main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /go/bin
COPY --from=build /go/src/app/bin .
COPY --from=build /go/src/app/env_developer .env

EXPOSE ${PORT}
ENTRYPOINT /go/bin/web-app --port ${PORT}