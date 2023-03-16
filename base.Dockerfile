# Образ на основе которого будет создан контейнер
FROM apache/airflow:2.5.1-python3.9

LABEL maintainer="Vladislav Nagaev <vladislav.nagaew@gmail.com>"

# Изменение рабочего пользователя
USER root

# Выбор рабочей директории
WORKDIR /

ENV \ 
    # Выбор time zone
    DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Moscow \
    # --------------------------------------------------------------------------
    # Переменные окружения для Python 
    # --------------------------------------------------------------------------
    # - не создавать файлы кэша .pyc, 
    PYTHONDONTWRITEBYTECODE=1 \
    # - не помещать в буфер потоки stdout и stderr
    PYTHONUNBUFFERED=1 \
    # - установить фиксированное начальное число для генерации hash() типов, охватываемых рандомизацией хэша
    PYTHONHASHSEED=1 \
    # - отключить проверку версии pip
    PIP_DISABLE_PIP_VERSION_CHECK=1 
    # --------------------------------------------------------------------------

# Копирование файлов проекта
COPY ./requirements.txt /tmp/requirements.txt

RUN \
    # --------------------------------------------------------------------------
    # Базовая настройка операционной системы
    # --------------------------------------------------------------------------
    # Установка пароль пользователя root 
    echo "root:root" | chpasswd && \
    # Замена ссылок на зеркало (https://launchpad.net/ubuntu/+archivemirrors)
    sed -i 's/htt[p|ps]:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirror.truenetwork.ru\/ubuntu/g' /etc/apt/sources.list && \
    # Обновление путей
    apt --yes update && \
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # Установка базовых пакетов
    # --------------------------------------------------------------------------
    # Установка C compiler (GCC)
    apt install --no-install-recommends --yes build-essential && \
    # Установка gssapi
    apt install --no-install-recommends --yes libkrb5-dev && \
    # libsasl
    apt install --no-install-recommends --yes libsasl2-dev && \
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # Установка пакетов Python
    # --------------------------------------------------------------------------
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir --use-pep517 --requirement /tmp/requirements.txt && \
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # Удаление неактуальных пакетов, директорий, очистка кэша
    # --------------------------------------------------------------------------
    # apt remove --yes libsasl2-dev libkrb5-dev build-essential && \
    apt --yes autoremove && \
    rm -rf /var/lib/apt/lists/*
    # --------------------------------------------------------------------------

# Выбор пользователя по-умолчанию
USER airflow

# Точка входа
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint"]
