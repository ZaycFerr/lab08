FROM ubuntu:20.04

# Отключаем интерактивные диалоги apt
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем компиляторы, CMake и утилиты для работы Hunter
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    cmake \
    make \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Копируем твой настоящий код проекта внутрь контейнера
COPY . /home/app
WORKDIR /home/app

# Собираем проект по схеме
RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install

# Настройка путей логирования согласно заданию
RUN mkdir -p /home/logs
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

# Переходим в папку со скомпилированным исполняемым файлом
WORKDIR _install/bin

# Запускаем твою реальную программу
ENTRYPOINT ["./demo"]
