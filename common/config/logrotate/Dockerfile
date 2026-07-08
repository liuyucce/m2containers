# Minimal logrotate sidecar, replacing the unmaintained tutum/logrotate image
# (Docker image manifest schema 1, which Docker 27+ refuses to pull by default).
#
# Uses the genuine `logrotate` package on Alpine — both free for commercial use
# (logrotate: GPL-2.0, Alpine: MIT/free), actively maintained, and published as a
# modern multi-arch OCI image. Each environment mounts its own
# /etc/logrotate.conf and /log volume (see the per-env docker-compose.yml); this
# image simply runs logrotate on a fixed interval. logrotate itself decides what
# is actually due for rotation from the mounted config and its state file.
FROM alpine:3.21

# gzip is pulled in explicitly for the `compress` directive (avoids relying on
# the busybox applet behaving identically to GNU gzip).
RUN apk add --no-cache logrotate gzip

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Seconds between logrotate runs. Hourly is plenty for the daily/size rules in
# the mounted config; override per-environment if needed.
ENV LOGROTATE_INTERVAL=3600

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
