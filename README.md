# docker-forestatrisk-tropics

Docker container to run the `forestatrisk` Python package.

The docker comes preinstalled with Debian buster, Python3, GDAL, and dependencies to run the
`forestatrisk` Python package.

## Usage

You can pull the container by running 

```shell
docker pull ghislainv/docker-forestatrisk-tropics.
```

Using singularity (https://sylabs.io/guides/2.6/user-guide/build_a_container.html#downloading-a-existing-container-from-docker-hub) on the MBB cluster

```shell
singularity build forestatrisk-tropics.simg docker://ghislainv/docker-forestatrisk-tropics
```
