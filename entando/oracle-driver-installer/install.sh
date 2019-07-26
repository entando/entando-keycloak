#!/usr/bin/env bash
if [ -n "${ORACLE_REPO_USER}" ] && [ -n "${ORACLE_REPO_PASSWORD}" ] ; then
    if ls ${JBOSS_HOME}/modules/system/layers/base/com/oracle/jdbc/main/ojdbc*.jar ; then
        echo "Oracle driver already  installed"
    else
        sed "s/ORACLE_REPO_USER/${ORACLE_REPO_USER}/g" settings-base.xml > settings.xml
        sed -i "s/ORACLE_REPO_PASSWORD/${ORACLE_REPO_PASSWORD}/g" settings.xml
        mvn clean package -s settings.xml -Doracle.maven.repo="${ORACLE_MAVEN_REPO:-https://maven.oracle.com}" || { echo "Could not download Oracle dependency"; exit 23; }
        mkdir -p "${JBOSS_HOME}/modules/system/layers/base/com/oracle/jdbc/main"
        cp module.xml "${JBOSS_HOME}/modules/system/layers/base/com/oracle/jdbc/main/"
        cp *.jar "${JBOSS_HOME}/modules/system/layers/base/com/oracle/jdbc/main/"
    fi
fi
