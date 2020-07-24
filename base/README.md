# docker-base

A ubuntu-based common docker image to be used for all NXTlytics Docker containers

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/base)

## How do I use this?

In your `Dockerfile`:
```
FROM nxtlytics/base:<pick a tag from hub.docker.com>
```

## What *should* I use this for?

Use this as a starting point for: 

- Building language/tooling specific base images
- Running compiled applications found in `apt`

## What should I not use this for?

This is not the place for:

- Language specific tooling
- Large uncommon libraries (CUDA/ML)
- Architecture-specific (ARM, etc) tooling or compilers

## Important note:

- Make sure the nexus credentials have *read-only* access

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.
