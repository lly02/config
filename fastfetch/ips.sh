#!/usr/bin/env bash
export PATH="/usr/sbin:/sbin:/usr/bin:/bin:$PATH"
IP=$(command -v ip || echo /usr/sbin/ip)
FILTER='$1 != "lo" && $1 != "docker0" && $1 !~ /^br-/ && $1 !~ /^veth/'

case "$1" in
  v4)
    "$IP" -4 -brief addr show scope global \
      | awk "$FILTER {print \$1, \$3; exit}"
    ;;
  v6)
    "$IP" -6 -brief addr show scope global \
      | awk "$FILTER {print \$1, \$3; exit}"
    ;;
  all)
    "$IP" -4 -brief addr show scope global \
      | awk "$FILTER {printf \"%s:%s \", \$1, \$3}"
    ;;
  *)
    echo "usage: ips.sh v4|v6|all" >&2
    exit 1
    ;;
esac
