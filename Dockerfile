#FROM        quay.io/prometheus/busybox:latest
#MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

#COPY blackbox_exporter  /bin/blackbox_exporter
#COPY blackbox.yml       /etc/blackbox_exporter/config.yml

#EXPOSE      9115
#ENTRYPOINT  [ "/bin/blackbox_exporter" ]
#CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]

FROM arm32v7/golang:1.9.2 AS build-env
ADD . /src
RUN cd /src
WORKDIR /src
RUN go get -d -v
RUN  CGO_ENABLED=0 GOARCH=arm GOOS=linux go build -o blackbox_exporter 

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /src/blackbox_exporter /bin/
COPY blackbox.yml       /etc/blackbox_exporter/config.yml

EXPOSE 9324

ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
#ENTRYPOINT ./mosquitto_exporter


