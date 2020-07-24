# docker-base-python38

A ubuntu-based Python 3.8 base container

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/python38)

## How do I use this?

In your `dockerfile`:
```
FROM nxtlytics/python38:<pick a tag from hub.docker.com>

# Add your source files
ADD app/ /app

# Install pipenv dependencies
RUN pipenv install

# Set command, make sure your main app is named `main.py`
CMD pipenv run /app/main.py
```

## What *should* I use this for?

Use this as a starting point for: 

- Applications using Python 3.8 as their runtime

## What should I not use this for?

This is not the place for:

- Large uncommon libraries (CUDA/ML)
- Architecture-specific (ARM, etc) tooling or compilers

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.
