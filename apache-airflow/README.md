# Apache Airflow

[DocherHUB repository](https://hub.docker.com/r/nxtlytics/apache-airflow)

## Overview

Container image for running Apache Airflow with a `CeleryExecutor`.

## Environment Variables

|     Environment Variable | Default Value                                                                          |                                                                                                                                       Description |
|                      --- | ---                                                                                    |                                                                                                                                               --- |
|             `FERNET_KEY` | -                                                                                      | Encrypt passwords in the connection configuration. It guarantees that a password encrypted using it cannot be manipulated or read without the key |
| `AIRFLOW__CORE__DB_HOST` | -                                                                                      |                                                             Airflow's PostreSQL Database fully qualified domain name (FQDN) used for Airflow runs |
| `AIRFLOW__CORE__DB_PORT` | `5432`                                                                                 |                                                                                               Relational Database port, if you have to specify it |
| `AIRFLOW__CORE__DB_NAME` | -                                                                                      |                                                                                                                          Relational Database name |
| `AIRFLOW__CORE__DB_USER` | -                                                                                      |                                                                                                                      Relational Database username |
| `AIRFLOW__CORE__DB_PASS` | -                                                                                      |                                                                                                                      Relational Database password |
|             `REDIS_HOST` | -                                                                                      |                                                                                                 Redis endpoint fully qualified domain name (FQDN) |
|             `REDIS_PORT` | `6379`                                                                                 |                                                                                                                                        Redis port |
|            `REDIS_DBNUM` | `1`                                                                                    |                                                                                                                      Redis Database Number to use |
|           `AIRFLOW_MODE` | `webserver`                                                                            |                                                                                             One of `webserver`, `scheduler`, `flower` or `worker` |
|            `STATSD_HOST` | `172.17.0.1`                                                                           |                                                               [StatsD](https://www.datadoghq.com/blog/statsd/) fully qualified domain name (FQDN) |
|            `STATSD_PORT` | `8125`                                                                                 |                                                 [StatsD](https://statsd.readthedocs.io/en/latest/configure.html#from-the-environment) server port |
|          `STATSD_PREFIX` | -                                                                                      |                                                      [StatsD](https://statsd.readthedocs.io/en/latest/configure.html#from-the-environment) prefix |
|   `AIRFLOW_AUTHENTICATE` | `False`                                                                                |                                                                                                            Require Google Authentication to login |
|        `OAUTH_CLIENT_ID` | -                                                                                      |                                                                                                                                  Google Client ID |
|    `OAUTH_CLIENT_SECRET` | -                                                                                      |                                                                                                                              Google Client Secret |
|         `GOOGLE_DOMAINS` | -                                                                                      |                                                                                                    Comma Separated G Suite Domains to allow login |
|             `SENTRY_DSN` | -                                                                                      |                                                                                                                     Sentry Data Source Name (DSN) |
|     `SENTRY_ENVIRONMENT` | `develop`                                                                              |                                                                                             Sentry environment for this project to send errors as |
|      `HOSTNAME_CALLABLE` | `socket.getfqdn`                                                                       |                                     Hostname by providing a path to a callable, which will resolve the hostname. The format is `package:function` |
|                   `REPO` | -                                                                                      |                                                                                                            git repository `git-sync.sh` will pull |
|                 `BRANCH` | -                                                                                      |                                                                                                     git repository branch `git-sync.sh` will pull |
|                    `DIR` | -                                                                                      |                                                                                    local directory where `git-sync.sh` will clone a repository to |
|              `REPO_HOST` | -                                                                                      |                                                                                     Fully Qualified Domain Name (FQDN) of the git repository host |
|              `REPO_PORT` | `22`                                                                                   |                                                                                                   port on which the git server serves its content |
|            `PRIVATE_KEY` | -                                                                                      |                                                                                            Private SSH Key `git-sync.sh` will use to authenticate |
|              `SYNC_TIME` | -                                                                                      |                                                                                                          How many seconds between each `git pull` |

### How to login

1. Go to URL and login using your G Suite Credentials

## Running it locally

1. Build the image

```shell
$ docker build -t nxtlytics/apache-airflow:local-test .
```

2. Create a `dev.env` file using the snippet below as an example:

```shell
# postgres container
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow
# apache-airflow container
AIRFLOW__CORE__DB_HOST=postgres
AIRFLOW__CORE__DB_USER=airflow
AIRFLOW__CORE__DB_PASS=airflow
AIRFLOW__CORE__DB_NAME=airflow
REDIS_HOST=redis
REDIS_DBNUM=1
LOAD_EX=n
FERNET_KEY= # the result of $(openssl rand -base64 32)
REPO=git@github.com:your-org/repository-where-dags-live.git
BRANCH=some-branch-with-dags
DIR=/usr/local/airflow/dags
REPO_HOST=github.com
PRIVATE_KEY=-----BEGIN OPENSSH PRIVATE KEY-----\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXXXX\n-----END OPENSSH PRIVATE KEY-----
SYNC_TIME=5
```

3. Lift the stack with `docker-compose`

```shell
$ docker-compose up
```

4. In your browser open a tab for each of these
  - [Airflow Web Server](http://localhost:8080)
  - [Celery's web UI called Flower](http://localhost:5555)

### How to run more workers locally

1. Lift the stack in detach mode

```shell
$ docker-compose up -d
Creating apache-airflow_postgres_1 ... done
Creating apache-airflow_redis_1    ... done
Creating apache-airflow_webserver_1 ... done
Creating apache-airflow_worker_1    ... done
```

2. Scale `worker`

```shell
$ docker-compose scale worker=2
WARNING: The scale command is deprecated. Use the up command with the --scale flag instead.
Starting apache-airflow_worker_1 ... done
Creating apache-airflow_worker_2 ... done
```

## Related links

- Thanks to [puckel/docker-airflow](https://github.com/puckel/docker-airflow)
- [astronomer/airflow-guides](https://github.com/astronomer/airflow-guides)
- [Airflow Best Practices](https://airflow.apache.org/docs/stable/best-practices.html)
- [Do not collect on Spark's Data Driver](https://luminousmen.com/post/spark-tips-dont-collect-data-on-driver)
- [teamclairvoyant/airflow-maintenance-dags](https://github.com/teamclairvoyant/airflow-maintenance-dags)
