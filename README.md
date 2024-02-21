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
