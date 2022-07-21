FROM alpine as builder

ARG ALERTMANAGER_VERSION
ENV VERSION=$ALERTMANAGER_VERSION

WORKDIR /tmp
ADD https://github.com/prometheus/alertmanager/releases/download/v0.24.0/alertmanager-0.24.0.linux-amd64.tar.gz /tmp/alertmanager-0.24.0.linux-amd64.tar.gz
RUN tar -xf alertmanager-0.24.0.linux-amd64.tar.gz

FROM alpine
COPY --from=builder   /tmp/alertmanager-0.24.0.linux-amd64/alertmanager /bin/alertmanager
COPY --from=builder   /tmp/alertmanager-0.24.0.linux-amd64/amtool /bin/amtool
COPY --from=builder   /tmp/alertmanager-0.24.0.linux-amd64/alertmanager.yml /etc/alertmanager/alertmanager.yml
COPY config/alertmanager.yml /etc/alertmanager/alertmanager.yml
COPY bin/promboot.sh      /bin/promboot.sh

RUN chmod +x /bin/promboot.sh && mkdir -p /alertmanager && \
    chown -R nobody:nogroup /etc/alertmanager /alertmanager

ARG GIT_COMMIT
LABEL git-ref=$CI_COMMIT_SHA

USER       nobody
EXPOSE     9093
VOLUME     [ "/alertmanager" ]
WORKDIR    /alertmanager
CMD        [ "/bin/promboot.sh" ]
