# Jupyterhub Single-User Container Image

Start new jupyterhub single user container images from this one

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/jupyterhub-singleuser-base)

# Notes

- Locking to `google-drive-ocamlfuse=0.7.21-0ubuntu1~ubuntu18.04.1` to avoid issues with config file format changes

## How to test

- on 2 different terminals run the following

Terminal 1

```shell
docker run --device=/dev/fuse --cap-add sys_admin  --env-file .env --rm nxtlytics/jupyterhub-singleuser-base:test
```

Terminal 2

```shell
docker exec -it $(docker ps | grep 'nxtlytics/jupyterhub-singleuser-base:test' | awk '{ print $1 }') bash
# ls /mnt/gdrive/
'Folder in Google Drive'
```

## Example `.env` file

```
GDRIVE_CLIENT_ID=<See Google Developer Console>
GDRIVE_CLIENT_SECRET=<See Google Developer Console>
GDRIVE_CALLBACK_URL=<See Google Developer Console>
GDRIVE_ACCESS_TOKEN=<OAUTH ACCESS TOKEN>
GDRIVE_REFRESH_TOKEN=<OAUTH REFRESH TOKEN>
DEBIAN_FRONTEND=noninteractive
```

# Related links

- [mitcdh/docker-google-drive-ocamlfuse](https://github.com/mitcdh/docker-google-drive-ocamlfuse)
- [astrada/google-drive-ocamlfuse](https://github.com/astrada/google-drive-ocamlfuse)
- [pass refresh token](https://github.com/astrada/google-drive-ocamlfuse/issues/591)
- [team drives](https://github.com/astrada/google-drive-ocamlfuse/wiki/Team-Drives)
