# A disposable Ubuntu server for the demo: sshd, key-only login, and a sudo-capable deploy user
FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server sudo \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash deploy \
    && echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/deploy \
    && mkdir -p /run/sshd \
    && sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/; s/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
EXPOSE 22 80
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
