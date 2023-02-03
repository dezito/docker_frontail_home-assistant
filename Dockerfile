FROM node:10.16.0-alpine

ARG FRONTAIL_VERSION

LABEL maintainer="Thomas Sloth <thomas@sloth.nu>" \
    description="Home-Assistant log viewer"

RUN apk add --no-cache wget

RUN npm install frontail@$FRONTAIL_VERSION -g --production --unsafe-perm

RUN FRONTAIL_BASE="/usr/local/lib/node_modules/frontail" \
    && wget     -O ${FRONTAIL_BASE}/preset/home-assistant.json \
    https://raw.githubusercontent.com/dezito/docker_frontail_home-assistant/master/home-assistant.json \
    && wget     -O ${FRONTAIL_BASE}/web/index.html \
    https://raw.githubusercontent.com/dezito/docker_frontail_home-assistant/master/index.html \
    && wget     -O ${FRONTAIL_BASE}/web/assets/styles/bootstrap.min.css \
    https://raw.githubusercontent.com/dezito/docker_frontail_home-assistant/master/bootstrap.min.css \
    && wget     -O ${FRONTAIL_BASE}/web/assets/styles/home-assistant.css \
    https://raw.githubusercontent.com/dezito/docker_frontail_home-assistant/master/home-assistant.css

RUN mkdir -p /home-assistant
RUN ln -s /home-assistant/home-assistant.log /var/log/home-assistant.log

EXPOSE 9001
CMD frontail \
    --disable-usage-stats \
    --ui-highlight \
    --ui-highlight-preset /usr/local/lib/node_modules/frontail/preset/home-assistant.json \
    --theme home-assistant\
    -l 2000 \
    -n 200 \
    ${FRONTAIL_OPTS} \
    /var/log/home-assistant.log

