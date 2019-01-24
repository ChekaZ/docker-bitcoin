FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOINPLUS_VERSION 2.7.0
ENV BITCOINPLUS_URL https://downloads.bitcoinplus.org/bitcoinplus-2.7.0-x86_64.tar.gz
ENV BITCOINPLUS_SHA256 753547b23988124defbf9bee029b4902d6277ce467c63f2ad6588c53817b2251

# install bitcoinplus binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoinplus.tar.gz "$BITCOINPLUS_URL" \
	&& echo "$BITCOINPLUS_SHA256 bitcoinplus.tar.gz" | sha256sum -c - \
	#&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$BITCOINPLUS_PGP_KEY" \
	#&& wget -qO bitcoinplus.asc "$BITCOINPLUS_ASC_URL" \
	#&& gpg --verify bitcoinplus.asc bitcoinplus.tar.gz \
	&& tar -xzvf bitcoinplus.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoinplus \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoinplus
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 17298 17299 27298 27299 18444 18445
CMD ["bitcoinplusd"]