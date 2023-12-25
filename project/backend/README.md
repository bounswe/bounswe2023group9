# Backend service of collaborative_science_platform project

This project uses Python 3.11, Django 4.2.6, and PostgreSQL 14.10

## Dockerization

To build a docker image, 
 - `docker build --tag <your-tag> .`
To run,
 - `docker run -p 8000:8000 <your-tag>`
The first port number (8000) is the port number of your machine your service runs. Please be sure that the specified port is available. The second one is your container's port number and should be same as the one exported in the Dockerfile. (8000 for this project.)

Dont forget to set the following environment variables,
- DJANGO_SECRET_KEY: You can generate one by running `python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`. Note that, this key should be kept hidden from public and you cannot change it later since all of the hashes are generated from this key.
- DATABASE_NAME: should be the name of the PostgreSQL database
- DATABASE_USER: should be the username of the owner of the created database, for root user: postgres
- DATABASE_PASSWORD: should be the password of the owner of the created database, for root user: postgres
- DATABASE_HOST: should be the address of your database server, in local: 127.0.0.1
- DATABASE_PORT: should be the port number of your database server, default: 5432

You can set them while running the container like the following
- `docker run -p 8000:8000 -e DJANGO_SECRET_KEY=<your-secret-key> <your-tag>`

## Database

In your database server, ensure you have PostgreSQL 14.10 installed and you are in your psql interface authenticated with a user eligible to create database. You may want to check [PostgreSQL documentation](https://www.postgresql.org/files/documentation/pdf/14/postgresql-14-A4.pdf) or [PostgreSQL download page](https://www.postgresql.org/download/).

To create the database, run
 - `CREATE DATABASE "<your-backend-database-name>";`

After you create the database, you can run your docker container. When the docker starts to run, it first makes the migrations and creates the schemas if they were not created yet.
