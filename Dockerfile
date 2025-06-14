FROM node:lts-slim AS runner

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq

RUN mkdir /esy

ENV NPM_CONFIG_PREFIX=/esy
RUN npm install -g --unsafe-perm esy@latest

# Runner
ENV PATH=/esy/bin:$PATH

# USER node
WORKDIR /opt/test-runner

# Pre-install packages
COPY esy.json .
COPY esy.lock ./esy.lock
RUN esy install

COPY package.json .
COPY package-lock.json .
RUN npm install

# RUN apt-get purge -y curl git ca-certificates && \
#     apt-get autoremove -y && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
