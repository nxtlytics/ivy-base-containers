# docker-base-node12

A ubuntu-based Node.js 12 base container

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/node12)

## How do I use this?

In your `dockerfile`:
```
FROM nxtlytics/node12:<pick a tag from hub.docker.com>

# Add your source files
ADD .

# Install npm dependencies
RUN npm install

# Babelify your sauce
RUN npm build

# Set command
CMD node /app/dist/index.js
```

## What *should* I use this for?

Use this as a starting point for: 

- Applications using Node.js 12 as their runtime

## What should I not use this for?

This is not the place for:

- Large uncommon libraries (CUDA/ML)
- Architecture-specific (ARM, etc) tooling or compilers

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.
