# Jenkins agent containers

- [jdk](https://hub.docker.com/r/nxtlytics/jenkins-jdk)
- [nodejs](https://hub.docker.com/r/nxtlytics/jenkins-nodejs)
- [python37](https://hub.docker.com/r/nxtlytics/jenkins-python37)
- [python38](https://hub.docker.com/r/nxtlytics/jenkins-python38)
- [python39](https://hub.docker.com/r/nxtlytics/jenkins-python39)
- [ruby](https://hub.docker.com/r/nxtlytics/jenkins-ruby)
- [ruby-jemalloc](https://hub.docker.com/r/nxtlytics/jenkins-ruby-jemalloc)

## How do I use this?


## Why `1000` for `gid` and `uid`?

We decided to use the same as [jenkinsci/docker-agent](https://github.com/jenkinsci/docker-agent/blob/6e4b1e09465e9fac9c0f234f38988353527724e9/11/buster/Dockerfile#L26-L29)

## Found a bug? Got suggestions?

Open an issue, or make a PR if you have suggested changes here.

## We used the following sources as inspiration

- [jenkins-agent image](https://github.com/jenkinsci/docker-agent/)
- [jenkins-inbound-agent image](https://github.com/jenkinsci/docker-inbound-agent/)
- [difi/jenkins-docker](https://github.com/difi/jenkins-docker/)
