#!/bin/bash
set -e

if [[ "$1" == "trezarcoin-cli" || "$1" == "trezarcoin-tx" || "$1" == "trezarcoind" || "$1" == "test_trezarcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/trezarcoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/trezarcoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.trezarcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.trezarcoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
