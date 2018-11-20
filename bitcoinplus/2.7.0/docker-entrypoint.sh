#!/bin/bash
set -e

if [[ "$1" == "bitcoinplus-cli" || "$1" == "bitcoinplus-tx" || "$1" == "bitcoinplusd" || "$1" == "test_bitcoinplus" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/bitcoinplus.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoinplus.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoinplus
	chown -h bitcoin:bitcoin /home/bitcoin/.bitcoinplus

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
