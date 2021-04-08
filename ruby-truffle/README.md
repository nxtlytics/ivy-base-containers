# docker-base-ruby-truffle-graalvm

A ubuntu-based Truffle Ruby 21.0.0 on GraalVM base container

[DockerHUB repository](https://hub.docker.com/r/nxtlytics/ruby-truffle)

## How do I use this?

In your `dockerfile`:
```
FROM nxtlytics/ruby-truffle:<pick a tag from hub.docker.com>

# Add your source files
ADD app/ /app

# Install bundle dependencies
RUN bundle install

CMD bundle exec main
```

## What *should* I use this for?

Use this as a starting point for: 

- Applications using Truffle Ruby 21.0.0 on GraalVM as their runtime

## What should I not use this for?

This is not the place for:

- Architecture-specific (ARM, etc) tooling or compilers

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.

## Known issues

- Install in `/opt` see [oracle/truffleruby#1389](https://github.com/oracle/truffleruby/issues/1389)
- We do not run `gem update --system`, this because TruffleRuby does not fully supports it yet, see [oracle/truffleruby#1479](https://github.com/oracle/truffleruby/issues/1479)
- See compatibility [here](https://github.com/oracle/truffleruby/blob/master/doc/user/compatibility.md)
