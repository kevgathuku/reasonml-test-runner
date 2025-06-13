FROM node:lts-slim AS runner

ENV TERM=dumb LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

RUN apt-get update && \
    apt-get install -y --no-install-recommends jq

RUN mkdir /esy
WORKDIR /esy

ENV NPM_CONFIG_PREFIX=/esy
RUN npm install -g --unsafe-perm esy@latest

ENV PATH=/esy/bin:$PATH

WORKDIR /home/node/test-runner

# Pre-install packages
COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .
ENTRYPOINT ["/home/node/test-runner/bin/run.sh"]
