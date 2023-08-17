#!/bin/ash

if test "${SSH_REGENERATE_HOST_KEY}" = "true"
then
    rm /etc/ssh/ssh_host_*
    ssh-keygen -A
fi

adduser -D -s /bin/ash ${SSH_USERNAME}
passwd -u ${SSH_USERNAME}

if test -n "${SSH_PASSWORD}"
then
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
fi

if test -n "${SSH_PUB_KEYS_URL}"
then
    mkdir -p /home/${USERNAME}/.ssh
    curl ${SSH_PUB_KEYS_URL} --output /home/${SSH_USERNAME}/.ssh/authorized_keys

    chown -R ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}
    chmod 700 /home/${SSH_USERNAME}/.ssh
    chmod 644 /home/${SSH_USERNAME}/.ssh/authorized_keys
fi

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"