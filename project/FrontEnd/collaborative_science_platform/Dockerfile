# Install Operating system and dependencies
FROM debian:latest AS build-env

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y  git
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y  libstdc++6
RUN apt-get install -y  libglu1-mesa
RUN apt-get install -y   fonts-droid-fallback
RUN apt-get install -y   lib32stdc++6
RUN apt-get install -y python3


RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Stage 2
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html