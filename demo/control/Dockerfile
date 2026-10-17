# The host server for the demo: the repo is mounted at /omni and almighty.sh is run from here
FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
WORKDIR /omni
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
