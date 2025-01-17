FROM alpine:3.16.2

RUN apk add --no-cache bash

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache "git" "openssh" "rsync" "augeas" "shadow" "rssh" && \
    deluser "$(getent passwd 33 | cut -d: -f1)" && \
    delgroup "$(getent group 33 | cut -d: -f1)" 2>/dev/null || true && \
    mkdir -p '~root/.ssh' '/etc/authorized_keys' && chmod 700 '~root/.ssh/' && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo -e "Port 22\n" >> '/etc/ssh/sshd_config' && \
    cp -a '/etc/ssh' '/etc/ssh.cache'

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
