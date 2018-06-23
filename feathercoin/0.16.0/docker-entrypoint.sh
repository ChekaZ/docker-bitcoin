#!/bin/bash
set -e

if [[ "$1" == "feathercoin-cli" || "$1" == "feathercoin-tx" || "$1" == "feathercoind" || "$1" == "test_feathercoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/feathercoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	rpcuser=2120078a533d58a8d0d51ab3ce7e7ca0c0db041f4d14d5df689dbd19dda6cf3b
	rpcpassword=2120078a533d58a8d0d51ab3ce7e7ca0c0db041f4d14d5df689dbd19dda6cf3b
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
