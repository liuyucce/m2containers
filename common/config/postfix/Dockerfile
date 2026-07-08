FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        postfix \
        supervisor \
        rsyslog \
        ca-certificates \
        libsasl2-modules \
    && rm -rf /var/lib/apt/lists/*

# Debian non-interactive install defaults to loopback-only
RUN postconf -e 'inet_interfaces = all'

# run.sh hardcodes /etc/ssl/certs/ca-bundle.crt for SES TLS
RUN ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-bundle.crt

# Pre-create mail log so the readlog tail doesn't race rsyslog at startup
RUN touch /var/log/mail.log

COPY etc/supervisor/conf.d/ /etc/supervisor/conf.d/
COPY run.sh /
RUN chmod +x /run.sh && newaliases

EXPOSE 25
CMD ["/run.sh"]
