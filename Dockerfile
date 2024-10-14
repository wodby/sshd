ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

RUN apk add --no-cache openssh; \
    \
    dockerplatform=${TARGETPLATFORM:-linux\/amd64};\
    gotpl_url="https://github.com/wodby/gotpl/releases/latest/download/gotpl-${dockerplatform/\//-}.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz --no-same-owner -C /usr/local/bin; \
    \
    echo GatewayPorts clientspecified >> /etc/ssh/sshd_config

RUN mkdir /root/.ssh
VOLUME /root/.ssh

EXPOSE 22

COPY templates/ /etc/gotpl/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-De"]
