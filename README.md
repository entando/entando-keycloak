# Entando Keycloak Theme
This repository contains a Keycloak instance with some custom Entando themes that change the appearance of:

* Keycloak SSO login screen
* Keycloak admin console

For more info about Keycloak themes, see the [official docs](https://www.keycloak.org/docs/latest/server_development/#_themes).

## Run
In order to run locally using Keycloak:

```
docker-compose up --build keycloak
```

then open the browser to show the login screen. Default port (host is localhost) and credentials are set up in the `docker-compose.yml` file.

## Two-factor authentication: the `entando-mfa` theme
The `entando-mfa` login theme extends `entando` and adds Entando-styled pages for multi-factor authentication:

| Page | Template |
|------|----------|
| Sign in with a one-time code (OTP) | `login-otp.ftl` |
| Authenticator app setup (QR code / manual key) | `login-config-totp.ftl` |
| Sign-in method selection ("Try another way") | `select-authenticator.ftl` |
| OTP removal during credential reset | `login-reset-otp.ftl` |
| Passkey (WebAuthn) sign in, registration and errors | `webauthn-authenticate.ftl`, `webauthn-register.ftl`, `webauthn-error.ftl` |
| Recovery codes (preview feature `recovery-codes`) | `login-recovery-authn-code-config.ftl`, `login-recovery-authn-code-input.ftl` |

All the other pages (username/password, password update, ...) are inherited from the `entando` theme.

The theme only changes the look of the pages: 2FA is enabled by the realm authentication flow.
`scripts/configure-mfa.sh` (requires `curl` and `jq`) configures a realm through the Admin REST API:

```
# OTP asked only to users that configured an authenticator app (built-in "browser" flow)
scripts/configure-mfa.sh -s http://localhost:8081/auth -r entando -m optional -u admin -p qwe123

# OTP mandatory for every user: users without an authenticator are asked to configure it at the next sign in
scripts/configure-mfa.sh -s http://localhost:8081/auth -r entando -m required -u admin -p qwe123

# back to the "entando" theme and the built-in "browser" flow
scripts/configure-mfa.sh -s http://localhost:8081/auth -r entando -m disabled -u admin -p qwe123
```

The same can be done manually from the admin console:
1. *Realm settings → Themes → Login theme*: `entando-mfa`.
2. *Authentication → Required actions*: `Configure OTP` enabled.
3. For mandatory 2FA: duplicate the `browser` flow, set the `Conditional OTP` sub-flow to *Required* and bind the new flow as *Browser flow*.

Users can add or remove authenticators from the account console (*Account security → Signing in*).

## Troubleshooting
To properly display theme changes, stop Keycloak, then

```
docker-compose up --build
```

If anything goes wrong, you can force removing the docker image with 

```
docker rmi entando/keycloak --force
docker-compose up --build
```
