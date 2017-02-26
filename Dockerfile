FROM nexeck/base-s6

MAINTAINER Marcel Beck <marcel@beck.im>

RUN apk add --no-cache openssh \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

COPY rootfs /

EXPOSE 22
