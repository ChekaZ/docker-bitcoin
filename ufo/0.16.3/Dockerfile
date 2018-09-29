FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV UFO_VERSION 0.16.3
ENV UFO_URL https://downloads.ufobject.com/ufo-0.16.3-x86_64-linux-gnu.tar.gz
ENV UFO_SHA256 1eb058b52985dbdd454dcb16c7c3ea7304bc3c81b403bcaec62b921dcefc09e0
#ENV UFO_ASC_URL https://github.com/fiscalobject/ufo/releases/download/v0.16.0/ufo-0.16.0-linux64.tar.gz.asc
#ENV UFO_PGP_KEY 0xf4f958124751434e

# install UFO binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO ufo.tar.gz "$UFO_URL" \
	&& echo "$UFO_SHA256 ufo.tar.gz" | sha256sum -c - \
	#&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$UFO_PGP_KEY" \
	#&& wget -qO ufo.asc "$UFO_ASC_URL" \
	#&& gpg --verify ufo.asc \
	&& tar -xzvf ufo.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.ufo \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.ufo
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9887 9888 19887 19888 18444 18445
CMD ["ufod"]