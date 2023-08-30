# PETSc image

This repository hosts the dockerfile to create a container image with a PETSc installation, to be used as a base image for custom DAMASK docker images.

## Build

The easiest way to build and deploy the image is through the [build-push](https://github.com/hpcflow/petsc-image/actions/workflows/build-push.yml) action, which can be manually triggered.

The image can be built and tested without pushing to ghcr.io by setting both push inputs to false.

### Building locally

Preferably build new images with the `--no-cache` option:
```
docker build --no-cache -t ghcr.io/hpcflow/petsc:latest .
```
Once the build is finished, push to ghcr with
```
docker push ghcr.io/hpcflow/petsc:latest
```
Rmember to also push a version tagged with the petsc and gcc version, e.g.:
```
docker build -t ghcr.io/hpcflow/petsc:3.18.4_gcc12.1.0 .
docker push ghcr.io/hpcflow/petsc:3.18.4_gcc12.1.0
```

## Fokring

If you want a custom version of PETSc that we are not hosting, feel free to either create an issue to request it, or fork this repo.

If you fork this repo, you will want to modify the default "target" repo. You can do so in `.github/workflows/build-push.yml` (line 31).
