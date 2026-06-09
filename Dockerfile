FROM ubuntu:20.04

# Предотвращаем зависание apt при установке пакетов
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Создаем директорию для логов
RUN mkdir -p /home/logs
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

# Создаем простую программу-заглушку прямо внутри контейнера
RUN mkdir -p /home/app
WORKDIR /home/app
RUN echo '#include <iostream>\n#include <fstream>\n#include <string>\nint main() {\n  std::ofstream out("/home/logs/log.txt", std::ios::app);\n  out << "Logger started\\n";\n  std::string line;\n  while (std::getline(std::cin, line)) {\n    out << line << "\\n";\n    std::cout << "Logged: " << line << std::endl;\n  }\n  return 0;\n}' > main.cpp

RUN g++ main.cpp -o demo

ENTRYPOINT ["./demo"]

