FROM google/dart:2.8 AS build

WORKDIR /app

ADD backend/pubspec.* /app/
ADD common /common
RUN pub get
ADD backend /app/
RUN pub get --offline; ls
RUN dart2native -o backend.exe bin/backend.dart

FROM gcr.io/distroless/base
WORKDIR /app
COPY --from=build /app/backend.exe .
ENTRYPOINT ["./backend.exe"]
