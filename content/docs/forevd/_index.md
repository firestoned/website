---
title: "forevd"
linkTitle: "forevd"
weight: 50
---

# forevd

`forevd` is a forward and reverse proxy that helps deliver authentication and, optionally, authorization as a sidecar. This project was created to help eliminate any need to add authentication into your application code.

[Project Repository](https://github.com/firestoned/firestoned/tree/main/forevd)

## Dependencies

`forevd` runs using Apache, so you will need to have httpd or a docker image of it available at runtime.

## Running `forevd`

The following provides some details on how to run `forevd`. The way the options work is that anything provided immediately on the CLI, are "global" defaults; if you then provide config (optionally files), via the `--locations`, `--ldap` or `--oidc` options, then those will override the CLI options.

## Config Files

You can optionally provide config files for more complicated setups. The config files use Jinja2 templating via environment variables, so, instead of putting values in directly, you can use the form `{{ ENV_VAR_NAME }}` to have the environment variable injected at runtime.

The following command line options support files: `--locations`, `--ldap` or `--oidc`, via the `@` symbol, similar to `curl`'s command line option `--data`, for example, `--oidc @etc/oidc.yaml`.

### Locations Config

This config allows you to provide much more control over each "location" or "endpoint" to your reverse proxy. For example, using different backends for different URLs or adding authorization.

```yaml
- path: /
  authz:
    join_type: "any"
    ldap:
      url: "ldaps://127.0.0.1/DC=foo,DC=example,DC=com"
      bind-dn: "foo"
      bind-pw: "{{ LDAP_BINDID_PASSWORD }}"
      groups:
        - "CN=foobar,OU=groups,DC=example,DC=com"
    users:
      - erick.bourgeois
```

### OIDC Config

This is useful for adding any other global OIDC config.

```yaml
ProviderMetadataUrl: "https://{{ OIDC_PROVIDER_NAME }}.us.auth0.com/.well-known/openid-configuration"
RedirectURI: "https://erick-pro.jeb.ca:8080/secure/redirect_uri"
ClientId: "{{ OIDC_CLIENT_ID }}"
ClientSecret: "{{ OIDC_CLIENT_SECRET }}"
Scope: '"openid profile"'
PKCEMethod: S256
RemoteUserClaim: nickname
```

## Mutual TLS

The following command provides termination of mTLS on `/` and passes connections to a backend at `http://0.0.0.0:8080`.

```bash
forevd --debug --listen 0.0.0.0:8080 \
    --ca-cert $PWD/../certs/ca/ca-cert.pem
    --cert $PWD/../certs/server.crt
    --cert-key $PWD/../certs/server.key
    --backend http://localhost:8081
    --location /
    --mtls require
    --server-name example.com
```

## Authorization

To add authorization, it's recommended you use a config file for the `--locations` command line. There is currently support for LDAP group lookups, static user names, or allow all valid users. Here are the keys supported:

1. `allow_all`: this key let's `forevd` know to allow all valid users through
2. `join_type`: this is the "join" type between all authorizations setup
3. `ldap`: this is the LDAP configuration for group lookups
4. `users`: a list of user names to verify against