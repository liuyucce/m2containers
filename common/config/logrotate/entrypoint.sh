#!/bin/sh
# Run logrotate on a fixed interval. logrotate decides whether each log is due
# for rotation from the mounted config (daily/size/etc.) and its own state file,
# so a simple periodic loop reproduces tutum/logrotate's hourly-cron behaviour
# without needing cron. The config uses copytruncate, so no signalling of other
# containers is required.
set -eu

CONF="${LOGROTATE_CONF:-/etc/logrotate.conf}"
INTERVAL="${LOGROTATE_INTERVAL:-3600}"
STATE="${LOGROTATE_STATE:-/var/lib/logrotate/logrotate.status}"
RUNCONF=/run/logrotate.conf

mkdir -p "$(dirname "$STATE")"

echo "[logrotate] starting: conf=$CONF interval=${INTERVAL}s state=$STATE"

while true; do
    if [ -f "$CONF" ]; then
        # logrotate refuses a config file not owned by root (a security check the
        # old tutum image predated). The config is bind-mounted from the host and
        # owned by the host user, so copy it to a root-owned file inside the
        # container (we run as root) and rotate from that copy.
        cp "$CONF" "$RUNCONF"
        chown root:root "$RUNCONF" 2>/dev/null || true
        chmod 0644 "$RUNCONF"
        logrotate --state "$STATE" "$RUNCONF" || echo "[logrotate] run exited non-zero ($?)"
    else
        echo "[logrotate] $CONF not found; skipping this cycle"
    fi
    sleep "$INTERVAL"
done
