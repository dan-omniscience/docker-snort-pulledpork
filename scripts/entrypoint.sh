#!/usr/bin/env bash
set -e

if ! [ -e "/etc/snort/snort.conf" ]; then
    /opt/scripts/setup-snort.sh
    /opt/scripts/setup-pulledpork.sh
    exec /usr/sbin/snort -u snort -g snort -c /etc/snort/snort.conf "$@"
fi

cron

exec "$@"