# collaborative_science_platform

A new Flutter project.

## Running the Flutter App locally

follow these steps:

1. Make sure you have Flutter installed. If not, you can install it by following the official Flutter installation guide: [Flutter Installation](https://flutter.dev/docs/get-started/install).

2. Navigate to your project directory:

`cd your-path-to-project/collaborative_science_platform`

3.  Ensure you have the latest dependencies by running:

`flutter pub get`

4. Build and run the web version of your app with the following command:

`flutter build web --release`

`flutter run -d web`

## Releasing an Android App

1. Navigate to your project directory:

`cd your-path-to-project/collaborative_science_platform`

2. Build the release APK for Android using the following command:

`flutter build apk --split-per-abi`

This will generate the APK files in the `build/app/outputs/flutter-apk` directory.

## Dockerization



To create a docker image, run:



`docker build -t <tag-name> .`



To create a container from that image:


`docker run -p 80:80 <tag-name>`


After starting the container you can access the website at `http://localhost`