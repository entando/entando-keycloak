FROM jboss/keycloak:9.0.3
LABEL MAINTAINER="Entando <dev@entando.com>"

COPY themes /opt/jboss/keycloak/themes
#COPY cli /opt/jboss/tools/cli
RUN export KEYCLOAK_HTTP_PORT=8080
#      cd  /opt/jboss/keycloak/modules/system/layers/base/com/oracle/jdbc/main/ && \
#      mkdir driver && \
#      curl https://repo1.maven.org/maven2/com/oracle/ojdbc/ojdbc8/19.3.0.0/ojdbc8-19.3.0.0.jar -o driver/ojdbc.jar

ENV KEYCLOAK_HTTP_PORT=8080
ENV KEYCLOAK_DEFAULT_THEME="entando"
EXPOSE 8080

CMD ["-b", "0.0.0.0"]
