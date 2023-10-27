# Backend of collaborative_science_platform project

This project uses django 4.2.

## Dockerization

To build a docker image, 
 - `docker build --tag <your-tag> .`
To run,
 - `docker run -p 8000:8000 <your-tag>`

Dont forget to set the following environment variables,
- DJANGO_SECRET_KEY
- DATABASE_NAME
- DATABASE_USER
- DATABASE_PASSWORD
- DATABASE_HOST
- DATABASE_PORT

You can set them while running the container like the following
- `docker run -p 8000:8000 -e DJANGO_SECRET_KEY=<your-secret-key> <your-tag>`

