FROM alpine:3.18

ENV USERNAME anon

ENV SSH_PUB_KEYS_URL https://github.com/nexeck.keys

RUN apk add --no-cache openssh \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

ADD ${SSH_PUB_KEYS_URL} /home/${USERNAME}/.ssh/authorized_keys

RUN passwd -d root && \
    ssh-keygen -A && \
    adduser -D -s /bin/ash ${USERNAME} && \
    passwd -u ${USERNAME} && \
    chmod 700 /home/${USERNAME}/.ssh && chmod 644 /home/${USERNAME}/.ssh/authorized_keys && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}


EXPOSE 22

COPY rootfs /

ENTRYPOINT ["/entrypoint.sh"]