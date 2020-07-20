# Details about the container

## The `Dockerfile`

1. The contents of `utils` are copied to `/opt/utils` in the container
2. Move `/opt/utils/docker-entrypoint.sh` to `/usr/local/bin/docker-entrypoint.sh` and make it executable
3. Install `datadog-agent` version 7 using a Fake API Key
  - Delete the agent's config and all integrations (we don't want to duplicate the system's metrics)
    - `/etc/datadog-agent/datadog.yaml`
    - `/etc/datadog-agent/conf.d/*`
4. Download RDS' Certificate Authority bundles and install them using `update-ca-certificates`
  - This is good enough for the datadog agent to use the bundle
5. Download `ytt` to `/usr/local/bin/ytt` and make it executable
  - See https://get-ytt.io/#playground
6. Deleted apt cache

## `docker-entrypoint.sh`

1. Render datadog config based on the value of environment variable `DD_CONFIG`
2. Render PostgreSQL config based on the value of environment variable `POSTGRES_CONFIG`
3. Finally, run datadog agent as user `dd-agent`

## `DD_CONFIG`

See [full example](https://github.com/DataDog/datadog-agent/blob/ccf751e3019b12cdf9360eff223209d1b4b4ca56/pkg/config/config_template.yaml) and [etc.yml](../utils/datadog/etc.yml)

```json
{
  "api_key":"<Container DD Agent API Key in 1Password>",
  "hostname":"<sysenv shortname>-datadog-agent",
  "tags":[
    "<KEY>:<VALUE>",
    "Yes, as a string"
  ]
}
```
