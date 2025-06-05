FROM node:lts-slim  AS runner

RUN apt-get update && \
    apt-get install -y --no-install-recommends jq opam ca-certificates build-essential && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV NO_UPDATE_NOTIFIER=true

# Initialize OPAM
RUN opam init --disable-sandboxing -y && \
    eval $(opam env --switch=default)

RUN opam update
RUN opam install dune reason melange melange-jest -y

WORKDIR /opt/test-runner

# Pre-install packages
COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
