#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template "config.tpl" "out/ipfs.config"
provsn_template "nginx.conf" "out/6-ipfs.conf"

cat > out/ipfs.opts <<-EOF
-d
--name ipfs
--restart always
--net host
--memory 24g
--user ipfs
--env IPFS_PATH=/data/ipfs
--env IPFS_LOGGING=info
--entrypoint /usr/local/bin/start_ipfs
--log-driver=json-file
--log-opt max-size=100m
--log-opt max-file=2
-v $(lookup ipfs_repo):/data/ipfs
ipfs:$(lookup ipfs_ref | head -c 7)
daemon
$(lookup ipfs_daemon_opts)
--migrate=true
EOF
