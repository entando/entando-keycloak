FROM jboss/keycloak
LABEL MAINTAINER="Entando <dev@entando.com>"

COPY themes /opt/jboss/keycloak/themes

RUN export KEYCLOAK_HTTP_PORT=8080
ENV KEYCLOAK_HTTP_PORT=8080
EXPOSE 8080

CMD ["-b", "0.0.0.0"]
