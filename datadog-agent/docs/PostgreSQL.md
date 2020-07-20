# RDS PostgreSQL

## AWS Root Certificate

Source: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html

## Give `datadog` the ability to read stats from PostgreSQL

```shell
$ psql -h <rds.fqdn> -p 5432 -U <admin user> postgres
Password for user ********:
psql (12.2, server 11.5)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=> create user datadog with password '<REDACTED>';
CREATE ROLE
postgres=> grant pg_monitor to datadog;
postgres=> \q

$ psql -h <rds.fqdn> -p 5432 -U datadog postgres -c "select * from pg_stat_database LIMIT(1);" && echo -e "\e[0;32mPostgres connection - OK\e[0m" || echo -e "\e[0;31mCannot connect to Postgres\e[0m"
Password for user datadog:
....
Postgres connection - OK
```

## `POSTGRES_CONFIG`

See [full example](https://github.com/DataDog/integrations-core/blob/6040d5d2f3a4fc39f14360884b784374a4c061df/postgres/datadog_checks/postgres/data/conf.yaml.example) and [postgres.conf.yml](../utils/postgres/postgres.conf.yml)

```json
[
  {
    "host": "rds1.fqdn",
    "port": 5432,
    "username": "datadog",
    "password": "<redacted>",
    "dbname": "postgres",
    "tags": [
      "<KEY>:<VALUE>",
      "Yes, as a string",
      "You can override DD_CONFIG tags here"
    ]
  }
]
```
