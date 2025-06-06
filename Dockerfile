FROM node:lts-slim AS runner

ENV OPAMYES=1 \
    NO_UPDATE_NOTIFIER=true

RUN apt-get update && \
    apt-get install -y --no-install-recommends jq curl git opam ca-certificates && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Initialize OPAM
RUN opam init --bare --disable-sandboxing --shell-setup && \
    opam switch create default 5.3.0 && \
    eval $(opam env --switch=default)

RUN opam update
RUN opam install dune reason melange melange-jest

RUN apt-get remove -y curl git ca-certificates

WORKDIR /opt/test-runner

# Pre-install packages
COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
