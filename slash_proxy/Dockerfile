FROM caddy:2.7.4-alpine

COPY Caddyfile /etc/caddy/Caddyfile

RUN caddy fmt --overwrite /etc/caddy/Caddyfile


ARG APP=/app

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# stup new folder as the working directory
CMD caddy run --config /etc/caddy/Caddyfile --adapter caddyfile 2>&1
