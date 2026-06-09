FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Добавляем ca-certificates для безопасного скачивания пакетов Hunter
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    cmake \
    make \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY . /home/app
WORKDIR /home/app

# Сборка проекта
RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install

RUN mkdir -p /home/logs
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

WORKDIR _install/bin
ENTRYPOINT ["./demo"]

