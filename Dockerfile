FROM alpine:3.5

ENV GOTLP_VER 0.1.5

RUN apk add --no-cache \
        bash \
        ca-certificates \
        tar \
        wget \
        curl \
        openssh && \

    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTLP_VER}/gotpl-alpine-linux-amd64-${GOTLP_VER}.tar.gz \
        | tar xz -C /usr/local/bin && \

    echo GatewayPorts yes >> /etc/ssh/sshd_config

RUN mkdir /root/.ssh
VOLUME /root/.ssh

EXPOSE 22

COPY templates/ /etc/gotpl/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-De"]
