FROM google/dart:2.8

WORKDIR /app

ADD backend/pubspec.* /app
ADD common /common
RUN pub get
ADD backend /app
RUN pub get --offline
RUN dart2native -o backend.exe bin/backend.dart

FROM gcr.io/distroless/base
WORKDIR /app
COPY --from=0 /app/backend.exe .
ENTRYPOINT ["./backend.exe"]
