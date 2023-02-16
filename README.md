# Airflow Docker

## Quick Start

To run airflow, you first need to run [postgres](https://github.com/VladislavNagaev/Postgres-Docker) and [redis](https://github.com/VladislavNagaev/Redis-Docker) containers.

Fill the file requirements.txt with necessary packages.

Create database for airflow:
~~~
# open postgres container
docker exec -it postgres bash

# run psql
psql --username=postgres --dbname=postgres

# create user and db
CREATE USER airflow WITH PASSWORD 'airflow';
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
ALTER DATABASE airflow OWNER TO airflow;

# exit from psql
exit

# exit from container
exit
~~~

Build image:
~~~
make --jobs=$(nproc --all) --file Makefile 
~~~

Depoyment of containers:
~~~
docker-compose -f docker-compose.yaml --env-file ./airflow.env --profile flower up --build --force-recreate
~~~

## Technologies
---
Project is created with:
* Airflow version: 2.5.1
* Docker verion: 23.0.1
* Docker-compose version: v2.16.0
