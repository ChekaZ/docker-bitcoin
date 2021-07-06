# Docker-Trezarcoin


Trezarcoin uses peer-to-peer technology to operate with no central authority or banks; managing transactions and the issuing of Trezarcoin is carried out collectively by the network. Trezarcoin is open-source; its design is public, nobody owns or controls trezarcoin and everyone can take part. Through many of its unique properties, trezarcoin allows exciting uses that could not be covered by any previous payment system.

This Docker image provides `trezarcoin`, `trezarcoin-cli` and `trezarcoin-tx` applications which can be used to run and interact with a Trezarcoin server.

Images are provided for a range of current and historic trezarcoin forks.
To see the available versions/tags, please visit the appropriate pages on Docker Hub:

### Usage

To start a trezarcoind instance running the latest version:

```
$ docker run chekaz/trezarcoin
```

This docker image provides different tags so that you can specify the exact version of trezarcoin you wish to run. For example, to run the latest minor version in the `0.11.x` series (currently `0.11.2`):

```
$ docker run chekaz/trezarcoin:2.1.3
```

Or, to run the `2.1.3` release specifically:

```
$ docker run chekaz/trezarcoin:2.1.3
```

To run a trezarcoin container in the background, pass the `-d` option to `docker run`, and give your container a name for easy reference later:

```
$ docker run -d --rm --name trezarcoind chekaz/trezarcoin
```

Once you have a trezarcoin service running in the background, you can show running containers:

```
$ docker ps
```

Or view the logs of a service:

```
$ docker logs -f trezarcoind
```

To stop and restart a running container:

```
$ docker stop trezarcoind
$ docker start trezarcoind
```

Specific versions of these alternate clients may be run using the command line options above.

### Configuring trezarcoin

The best method to configure the trezarcoin server is to pass arguments to the `trezarcoind` command. For example, to run trezarcoin on the testnet:

```
$ docker run --name trezarcoind-testnet chekaz/trezarcoin trezarcoind -testnet
```

Alternatively, you can edit the `trezarcoin.conf` file which is generated in your data directory (see below).

### Data Volumes

By default, Docker will create ephemeral containers. That is, the blockchain data will not be persisted, and you will need to sync the blockchain from scratch each time you launch a container.

To keep your blockchain data between container restarts or upgrades, simply add the `-v` option to create a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/):

```
$ docker run -d --rm --name trezarcoind -v trezarcoin-data:/data chekaz/trezarcoin
$ docker ps
$ docker inspect trezarcoin-data
```

Alternatively, you can map the data volume to a location on your host:

```
$ docker run -d --rm --name trezarcoind -v "$PWD/data:/data" chekaz/trezarcoin
$ ls -alh ./data
```

### Using trezarcoin-cli

By default, Docker runs all containers on a private bridge network. This means that you are unable to access the RPC port (8332) necessary to run `trezarcoin-cli` commands.

There are several methods to run `bitclin-cli` against a running `trezarcoind` container. The easiest is to simply let your `trezarcoin-cli` container share networking with your `trezarcoind` container:

```
$ docker run -d --rm --name trezarcoind -v trezarcoin-data:/data chekaz/trezarcoin
$ docker run --rm --network container:trezarcoind chekaz/trezarcoin trezarcoin-cli getinfo
```

If you plan on exposing the RPC port to multiple containers (for example, if you are developing an application which communicates with the RPC port directly), you probably want to consider creating a [user-defined network](https://docs.docker.com/engine/userguide/networking/). You can then use this network for both your `trezarcoind` and `bitclin-cli` containers, passing `-rpcconnect` to specify the hostname of your `trezarcoind` container:

```
$ docker network create trezarcoin
$ docker run -d --rm --name trezarcoind -v trezarcoin-data:/data --network trezarcoin chekaz/trezarcoin
$ docker run --rm --network trezarcoin chekaz/trezarcoin trezarcoin-cli -rpcconnect=trezarcoind getinfo
```

### Complete Example

For a complete example of running a trezarcoin node using Docker Compose, see the [Docker Compose example](/example#readme).

### License

Configuration files and code in this repository are distributed under the [MIT license](/LICENSE).

### Contributing

All files are generated from templates in the root of this repository. Please do not edit any of the generated Dockerfiles directly.

* To add a new trezarcoin version, update [versions.yml](/versions.yml), then run `make update`.
* To make a change to the Dockerfile which affects all current and historical trezarcoin versions, edit [Dockerfile.erb](/Dockerfile.erb) then run `make update`.

If you would like to build and test containers for all versions (similar to what happens in CI), run `make`. If you would like to build and test all containers for a specific trezarcoin fork, run `BRANCH=core make`.
