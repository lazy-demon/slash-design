FROM debian:latest AS build-env

RUN apt-get update
RUN apt-get install -y curl git unzip

ARG FLUTTER_SDK=/usr/local/flutter
ARG APP=/app

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
RUN cd $FLUTTER_SDK && git checkout efbf63d9c66b9f6ec30e9ad4611189aa80003d31
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor -v

RUN mkdir $APP
COPY . $APP
WORKDIR $APP

RUN ls
RUN cd slash_flutter && flutter clean
RUN cd slash_flutter && flutter pub get
RUN cd slash_flutter && flutter build web --verbose

FROM nginx:1.25.2-alpine-slim
COPY --from=build-env /app/slash_flutter/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]