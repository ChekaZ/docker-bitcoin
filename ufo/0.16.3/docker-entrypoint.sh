#!/bin/bash
set -e

if [[ "$1" == "ufo-cli" || "$1" == "ufo-tx" || "$1" == "ufod" || "$1" == "test_ufo" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/ufo.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/ufo.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.ufo
	chown -h bitcoin:bitcoin /home/bitcoin/.ufo

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
