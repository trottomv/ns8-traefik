# Traefik

This module implements a proxy for web applications using [Traefik](https://doc.traefik.io/traefik/).

The module exposes 2 actions:
- `set-route`
- `get-route`
- `delete-route`
- `list-routes`
- `set-certificate`
- `get-certificate`
- `delete-certificate`
- `list-certificates`

## set-route

This action creates HTTP routes based on a combination of host and path, is possible to define three type
of rules:

* only `host`: These rules will capture all the requests directed to a specific host
* `host` and `path`: These rules will capture all the requests directed to a specific combination of host and path prefix
* only `path`: These rules will capture all the requests directed to a specific path prefix, regardless of the host.

This is the priority of the rules type evaluation (top-down):

1. only `host`
1. `host` and `path`
1. only `path`

### Parameters

- `instance`: the instance name, which is unique inside the cluster, mandatory
- `url`: the backend target URL, mandatory
- `host`: a fully qualified domain name as virtual host
- `path`: a path prefix, the matching evaluation will be performed whit and without the trailing slash, eg `/foo` will match `/foo` and `/foo/*`, also `/foo/` will match `/foo` and `/foo/*`
- `lets_encrypt`: can be `true` or `false`, if set to `true` request a valid Let's Encrypt certificate, mandatory
- `http2https` can be `true` or `false`, if set to `true` HTTP will be redirect to HTTPS, mandatory
- `strip_prefix`: can be `true` or `false`, if set to `true` the prefix of the requested path will be stripped from the original request before sending it to the downstream server.

### Examples

Only `host`
```
api-cli run set-route --agent module/traefik1 --data - <<EOF
{
  "instance": "module1",
  "url": "http://127.0.0.0:2000",
  "host": "module.example.org",
  "lets_encrypt": true,
  "http2https": true
}
EOF
```

`host` and `path`
```
api-cli run set-route --agent module/traefik1 --data - <<EOF
{
  "instance": "module1",
  "url": "http://127.0.0.0:2000",
  "host": "module.example.org",
  "path": "/foo",
  "lets_encrypt": true,
  "http2https": true
}
EOF
```
Only `path`

```
api-cli run set-route --agent module/traefik1 --data - <<EOF
{
  "instance": "module1",
  "url": "http://127.0.0.0:2000",
  "path": "/foo",
  "lets_encrypt": true,
  "http2https": true
}
EOF
```
## get-route

This action get an existing route. It returns a JSON object that describes the route configuration, if the
route is not found an empty JSON object is returned.
The action takes 1 parameter:
- `instance`: the instance name

Example:
```
api-cli run get-route --agent module/traefik1 --data '{"instance": "module1"}'
```

Output:
```json
{"instance": "module3", "host": "module.example.org", "path": "/foo", "url": "http://127.0.0.0:2000", "lets_encrypt": true, "http2https": true, "strip_prefix": false}
```

## delete-route

This action delets an existing route. It can be used when removing a module instance.
The action takes 1 parameter:
- `instance`: the instance name

Example:
```
api-cli run delete-route --agent module/traefik1 --data '{"instance": "module1"}'
```

## list-routes

This action returns a list of configured routes, the list is an JSON array, and if no route is configured, an
empty array is returned.
The action takes no parameter:

Example:
```
api-cli run list-routes --agent module/traefik1
```

Output:
```json
["module1", "module2", "module3"]
```

## set-certificate

Run this action to request a Let's Encrypt certificate if [HTTP-01
challenge](https://letsencrypt.org/docs/challenge-types/#http-01-challenge)
requirements are met.

It can be used when there is no hostname (or hostname + path) route
configured on traefik module or if the service is not make accessible via
traefik.

The action takes 1 parameter:
- `fqdn`: the fqdn of the requested certificate

Example:
```
api-cli run set-certificate --agent module/traefik1 --data "{\"fqdn\": \"$(hostname -f)\""
```

## get-certificate

Run this action to get the status of requested a Let's Encrypt certificate

The action takes 1 parameter:
- `fqdn`: the fqdn of the requested certificate

Example:
```
api-cli run get-certificate --agent module/traefik1 --data "{\"fqdn\": \"$(hostname -f)\""
```

Output:
```
{"fqdn": "example.com", "obtained": true}
```

## delete-certificate

This action deletes an existing route used for explicit request a certificate.

NB. The certificate will **not** actually be removed from traefik and if the conditions will remain in place it will be renewed.

The action takes 1 parameter:
- `fqdn`: the fqdn of the requested certificate

Example:
```
api-cli run delete-certificate --agent module/traefik1 --data "{\"fqdn\": \"$(hostname -f)\""
```

## list-certificates

This action returns a list of requested certificate, the list is an JSON array, and if no certificate was requested, an
empty array is returned.
The action takes no parameter:

Example:
```
api-cli run list-certificates --agent module/traefik1
```

Output:
```json
["example.com"]
```
