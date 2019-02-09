FROM golang:1.11 AS build
WORKDIR /go/src/cow
COPY . .
RUN go build


FROM golang:1.11
RUN apt-get update && \
    apt-get install -y gettext-base curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY --from=build /go/src/cow/cow .
COPY docker/rc.template ./.cow/

EXPOSE 7777

ENV LISTEN=http://127.0.0.1:7777 \
    ALWAYS_PROXY=false \
    PROXY=""

CMD envsubst < ./.cow/rc.template > ./.cow/rc && ./cow
