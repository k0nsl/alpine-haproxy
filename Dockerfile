FROM alpine:3.5
MAINTAINER k0nsl <i.am@k0nsl.orgm>

ENV CONSUL_TEMPLATE_VERSION=0.18.2 \
    HAPROXY_PID_FILE=/var/run/haproxy.pid \
    HAPROXY_CONFIG_FILE=/etc/haproxy/haproxy.cfg

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

COPY scripts/mkimage-alpine.bash scripts/apk-install /

RUN set -ex && \
    apk --update --no-cache add haproxy ca-certificates curl inotify-tools      && \
    chmod 0751 /opt/haproxy/reload                                              && \
    ln -s /opt/haproxy/reload /usr/local/bin/haproxy-reload                     && \
    chmod 0751 /opt/haproxy/up                                                  && \
    ln -s /opt/haproxy/up /usr/local/bin/haproxy-up                             && \
    cd /tmp                                                                     && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip            && \
    mv consul-template /usr/local/bin/consul-template                           && \
    rm -rf /tmp/* \
           /var/cache/apk/*

#      HTTP HTTPS STATS
EXPOSE 8000 8443  9000

ENTRYPOINT ["/init"]
CMD []
