FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV TREZARCOIN_VERSION 2.1.3
ENV TREZARCOIN_URL https://trezarcoin.com/Downloads/trezarcoin-2.1.3-linux64.tar.gz
ENV TREZARCOIN_SHA256 ff89cdc165fb2ba4d7025591982275f18af0b1fea60f807af5ac511b957355c1

# install trezarcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO trezarcoin.tar.gz "$TREZARCOIN_URL" \
	&& echo "$TREZARCOIN_SHA256 trezarcoin.tar.gz" | sha256sum -c - \
	#&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$TREZARCOIN_PGP_KEY" \
	#&& wget -qO trezarcoin.asc "$TREZARCOIN_ASC_URL" \
	#&& gpg --verify trezarcoin.asc trezarcoin.tar.gz \
	&& tar -xzvf trezarcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.trezarcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.trezarcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 17298 17299 27298 27299 18444 18445
CMD ["trezarcoind"]