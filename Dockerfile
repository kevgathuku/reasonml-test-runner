FROM ocaml/opam:debian-12-ocaml-5.2 AS runner

ENV OPAMYES=1 NO_UPDATE_NOTIFIER=true

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends jq git nodejs npm

# RUN opam repository set-url default https://opam.ocaml.org \
#  && opam update

USER opam
RUN opam install dune reason melange melange-jest

# RUN opam clean && \
#     apt-get purge -y curl git && \
#     apt-get autoremove -y && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
ENV NPM_CONFIG_PREFIX=/home/opam/npm-global
ENV PATH="/home/opam/npm-global/bin:${PATH}"
RUN mkdir -p /home/opam/npm-global && chown -R opam:opam /home/opam/npm-global

WORKDIR /home/opam/test-runner

# Pre-install packages
COPY --chown=opam:opam package.json .
COPY --chown=opam:opam package-lock.json .
RUN npm install

COPY . .
ENTRYPOINT ["/home/opam/test-runner/bin/run.sh"]
