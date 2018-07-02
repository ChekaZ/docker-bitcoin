#!/bin/bash
set -e

if [[ "$1" == "feathercoin-cli" || "$1" == "feathercoin-tx" || "$1" == "feathercoind" || "$1" == "test_feathercoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/feathercoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/feathercoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.feathercoin
	chown -h bitcoin:bitcoin /home/bitcoin/.feathercoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
