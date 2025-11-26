FROM ubuntu

# Устанавливаем переменную, чтобы избежать интерактивных вопросов
ENV DEBIAN_FRONTEND=noninteractive

# Установка OpenSSH сервера
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Устанавливаем Python, pip и venv
RUN apt install -y python3 python3-pip python3-venv

# Удаляем кэшированные списки пакетов APT
RUN rm -rf /var/lib/apt/lists/*

# Установка пароля для root (по умолчанию root без пароля)
RUN echo "root:1234" | chpasswd

# Разрешаем вход по паролю в конфиге sshd
RUN sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM .*/UsePAM no/' /etc/ssh/sshd_config

# Открываем порт 22
EXPOSE 22

# Запуск sshd в форграунде
CMD ["/usr/sbin/sshd", "-D"]
