FROM google/dart:2.8 AS build

WORKDIR /app

COPY backend/pubspec.* /app/
COPY common /common
RUN pub get
COPY backend/ /app/
RUN pub get --offline
RUN dart2native -o backend.exe bin/backend.dart

FROM gcr.io/distroless/base
WORKDIR /app
COPY --from=build /app/backend.exe .
ENTRYPOINT ["/app/backend.exe"]
