# docker-base-ruby

A ubuntu-based Ruby 2.7.2 base container

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/ruby)

## How do I use this?

In your `dockerfile`:
```
FROM nxtlytics/ruby:<pick a tag from hub.docker.com>

# Add your source files
ADD app/ /app

# Install bundle dependencies
RUN bundle install

CMD bundle exec main
```

## What *should* I use this for?

Use this as a starting point for: 

- Applications using Ruby 2.7.2 as their runtime

## What should I not use this for?

This is not the place for:

- Architecture-specific (ARM, etc) tooling or compilers

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.
