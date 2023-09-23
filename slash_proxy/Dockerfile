FROM caddy:2.7.4-alpine





ARG APP=/app

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# stup new folder as the working directory

WORKDIR $APP/slash_proxy


COPY Caddyfile /etc/caddy/Caddyfile

RUN caddy fmt --overwrite /etc/caddy/Caddyfile

CMD caddy run --config /etc/caddy/Caddyfile --adapter caddyfile 2>&1
