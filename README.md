# Airflow Docker

## Quick Start

To run airflow, you first need to run [postgres](https://github.com/VladislavNagaev/Postgres-Docker) and [redis](https://github.com/VladislavNagaev/Redis-Docker) containers.

Fill the file requirements.txt with necessary packages.

Prepare postgres DB:
~~~
cat ./initdb.sql | docker exec -i postgres psql --username=postgres --dbname=postgres
~~~

Build image:
~~~
make --jobs=$(nproc --all) --file Makefile 
~~~

Depoyment of containers:
~~~
docker-compose -f docker-compose.yaml --env-file ./airflow.env --profile flower up
~~~


## Interfaces:
---
* [Airflow WebUi](http://127.0.0.1:8080/login)


## Technologies
---
Project is created with:
* Airflow version: 2.5.1
* Docker verion: 23.0.1
* Docker-compose version: v2.16.0
