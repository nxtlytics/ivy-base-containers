# OpenJDK 11

A ubuntu-based OpenJDK 11 base container

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/jdk)

## How do I use this?

In your `dockerfile`:
```
FROM nxtlytics/jdk:<pick a tag from hub.docker.com>

# Add your source files
ADD app/ /app

# Install dependencies
RUN mvn

CMD <insert command to execute>
```

## What *should* I use this for?

Use this as a starting point for: 

- Applications using OpenJDK 11 as their runtime

## What should I not use this for?

This is not the place for:

- Large uncommon libraries (CUDA/ML)
- Architecture-specific (ARM, etc) tooling or compilers

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.
