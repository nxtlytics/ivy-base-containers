# DataDog Agent for monitoring managed services

## Documentation available [here](./docs/)

## Example: How to run the container

Note: `--rm` is just so the container doesn't stay after you're done with it

```
docker run --rm \
  -e 'DD_CONFIG={"api_key":"<Container DD Agent API Key>","hostname":"<sysenv shortname>-datadog-agent","tags":["ivy_environment:<sysenv shortname>","ivy_sysenv:<sysenv>","ivy_service:rds","ivy_role:postgresql","ivy_team:infeng@example.com", "ivy_createdby:ivy"]}' 
  -e 'POSTGRES_CONFIG=[{"host":"rds1.fqdn", "port":5432,"username":"datadog","password":"<redacted>", "dbname": "postgres", "tags": ["ivy_environment:dev","ivy_service:rds"]},{"host":"rds2.fqdn", "port":5432,"username":"datadog","password":"<redacted>", "dbname": "postgres", "tags": ["ivy_environment:dev","ivy_service:rds"]}]' \
  nxtlytics/datadog-agent:<TBD>
```
