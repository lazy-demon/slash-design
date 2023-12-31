FROM dart:2.19.0 AS build

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/main

FROM debian:buster-slim AS runtime 

ENV runmode=staging
ENV serverid=default
ENV logging=normal
ENV role=monolith

COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/main
COPY --from=build /app/config/ config/
COPY --from=build /app/generated/ generated/
COPY --from=build /app/web/ web/

ARG SERVERPOD_PASSWORDS
RUN echo "$SERVERPOD_PASSWORDS" > config/passwords.yaml
ARG DEV_ENV_VAR
# RUN echo "$DEV_ENV_VAR" > config/development.yaml

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

CMD app/bin/main --mode $runmode --server-id $serverid --logging $logging --role $role