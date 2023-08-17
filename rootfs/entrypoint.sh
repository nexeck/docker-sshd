#!/bin/ash

if test "${SSH_REGENERATE_HOST_KEY}" = "true"
then
    echo "Regenerating Host Keys"
    rm /etc/ssh/ssh_host_*
    ssh-keygen -A
fi

echo "Adding user ${SSH_USERNAME}"
adduser -D -s /bin/ash "${SSH_USERNAME}"
passwd -u "${SSH_USERNAME}"

echo "UserID: $(id -u ${SSH_USERNAME}) GroupID: $(id -g ${SSH_USERNAME})"

if test -n "${USER_DIRS_TO_CREATE}"
then
    dirs=$(echo "${USER_DIRS_TO_CREATE}" | tr "," "\n")
    for dir in ${dirs}
    do
        echo "Creating directory /home/${SSH_USERNAME}/${dir}"
        mkdir -p "/home/${SSH_USERNAME}/${dir}"
    done
fi

if test -n "${SSH_PASSWORD}"
then
    echo "Changing Password for ${SSH_USERNAME}"
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
fi

if test -n "${SSH_PUB_KEYS_URL}"
then
    echo "Adding SSH Pub Keys for ${SSH_USERNAME} from ${SSH_PUB_KEYS_URL}"
    mkdir -p "/home/${SSH_USERNAME}/.ssh"
    curl "${SSH_PUB_KEYS_URL}" --output "/home/${SSH_USERNAME}/.ssh/authorized_keys"

    chown -R ${SSH_USERNAME}:${SSH_USERNAME} "/home/${SSH_USERNAME}"
    chmod 700 "/home/${SSH_USERNAME}/.ssh"
    chmod 644 "/home/${SSH_USERNAME}/.ssh/authorized_keys"
fi

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"