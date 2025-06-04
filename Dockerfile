FROM ocaml/opam:debian-12-ocaml-5.2 AS runner

ENV PATH="/home/opam/.opam/5.2/bin:${PATH}"

RUN opam update
RUN opam install dune reason melange melange-jest

# Install Node.js and npm (using NodeSource for modern versions)
USER root
RUN apt-get update && \
    apt-get install -y curl jq gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    # smoke tests
    node --version && \
    npm --version && \
    rm -rf /var/lib/apt/lists/*

ENV NO_UPDATE_NOTIFIER=true

WORKDIR /opt/test-runner

# Pre-install packages
COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
