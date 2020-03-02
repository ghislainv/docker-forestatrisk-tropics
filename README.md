# docker-forestatrisk-tropics :whale:

Docker container to run the `forestatrisk` Python package on the
[MBB](https://mbb.univ-montp2.fr/MBB/index.php) cluster.

The docker comes preinstalled with Debian testing, Python3, GDAL,
RClone, and dependencies to run the `forestatrisk` Python package.

## Usage

### With docker

You can pull the container by running: 

```shell
docker pull ghislainv/docker-forestatrisk-tropics
```

To run an interactive terminal using the docker container:

```shell
sudo docker run -ti docker-forestatrisk-tropics
```

### With singularity

Using
[singularity](https://sylabs.io/guides/2.6/user-guide/build_a_container.html#downloading-a-existing-container-from-docker-hub)
on the MBB cluster:

```shell
singularity build forestatrisk-tropics.simg docker://ghislainv/docker-forestatrisk-tropics
```

To run an interactive terminal using the singularity image:

```shell
singularity shell forestatrisk-tropics.simg
```
