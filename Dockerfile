FROM alpine:3.20

ENV SSH_USERNAME anon
ENV SSH_PASSWORD ""
ENV SSH_PUB_KEYS_URL ""
ENV SSH_REGENERATE_HOST_KEY true
ENV USER_DIRS_TO_CREATE ""

RUN apk add --no-cache openssh curl \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

RUN passwd -d root && \
    ssh-keygen -A


EXPOSE 22

COPY rootfs /

ENTRYPOINT ["/entrypoint.sh"]
