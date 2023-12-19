FROM python:3.11.6-slim-bullseye

WORKDIR /app

COPY . .
RUN pip3 install -r requirements.txt
RUN apt-get update && apt-get -y install tk-dev

EXPOSE 8000

CMD ["python3", "manage.py", "makemigrations", "0.0.0.0:8000"]
CMD ["python3", "manage.py", "migrate", "0.0.0.0:8000"]
CMD ["python3", "manage.py", "makemigrations", "0.0.0.0:8000"]
CMD ["python3", "manage.py", "migrate", "0.0.0.0:8000"]
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
