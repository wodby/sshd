#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -b 2048 -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key -q
fi

if [[ ! -f /root/.ssh/id_rsa ]]; then
    ssh-keygen -b 2048 -q -t rsa -N "" -f /root/.ssh/id_rsa
    echo
    echo ----------------------------------------------
    echo Genrated RSA key:
    cat /root/.ssh/id_rsa.pub
    echo
    echo ----------------------------------------------
    echo
fi

mkdir -p /root/.ssh
gotpl /etc/gotpl/authorized_keys.tpl > /root/.ssh/authorized_keys
chmod 0700 -R /root/.ssh

exec "$@"
