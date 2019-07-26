FROM jboss/keycloak
LABEL MAINTAINER="Sergio Marcelino <s.marcelino@entando.com>"
ARG MAVEN_VERSION=3.5.4
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV MAVEN_HOME /usr/share/maven \
    HOME=/opt/jboss \
    MAVEN_CONFIG "$HOME/.m2" \
    KEYCLOAK_HTTP_PORT=8080
USER root
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    &&  tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
COPY ./themes /opt/jboss/keycloak/themes
COPY ./tools /opt/jboss/tools
COPY --chown=jboss:root ./entando /opt/entando
RUN chmod -Rf ug+rw /opt/entando/
USER jboss
RUN cd /opt/entando/sample-driver-installer/ \
    && ./install.sh \
    && chmod -Rf a+rw  $HOME/.m2
EXPOSE 8080
CMD ["-b", "0.0.0.0"]
