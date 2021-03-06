FROM n8nio/n8n
MAINTAINER Anderson Contreira <anderson.contreira@gmail.com>

#-----------------------------------------------------------------------------------------------------------------------
# ARGS Provided by user, weather from buildspec or docker-compose file
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#-----------------------------------------------------------------------------------------------------------------------
ARG SERVICE_PORT=5678
ARG PROJECT_NAME=n8n
ARG ENVIRONMENT_NAME=development
ARG NEW_RELIC_ENABLE_FLAG
ARG NEW_RELIC_APP_NAME
ARG NEW_RELIC_LICENSE_KEY
ARG NEW_RELIC_LOGFILE
ARG NEW_RELIC_LOGLEVEL

#-----------------------------------------------------------------------------------------------------------------------
# ENVS
#-----------------------------------------------------------------------------------------------------------------------
ENV SERVICE_PORT=$SERVICE_PORT
ENV PROJECT_NAME=$PROJECT_NAME
ENV ENVIRONMENT_NAME=$ENVIRONMENT_NAME
ENV NEW_RELIC_ENABLE_FLAG=$NEW_RELIC_ENABLE_FLAG
ENV NEW_RELIC_APP_NAME=$NEW_RELIC_APP_NAME
ENV NEW_RELIC_LICENSE_KEY=$NEW_RELIC_LICENSE_KEY
ENV NEW_RELIC_LOGFILE=$NEW_RELIC_LOGFILE
ENV NEW_RELIC_LOGLEVEL=$NEW_RELIC_LOGLEVEL
ENV LOG_STREAM=/tmp/stdout

#-----------------------------------------------------------------------------------------------------------------------
# install aws cli
#-----------------------------------------------------------------------------------------------------------------------
# gcc requirement && python e pip
RUN apk add --no-cache build-base \
                       python3-dev \
                       py3-pip \
                       make \
                       gcc \
                       libcurl \
                       curl \
                       bash \
    && rm -rf /var/cache/apk/* \

# upgrade pip
RUN pip install --upgrade pip

# install aws cli
RUN pip --no-cache-dir install --upgrade awscli

#-----------------------------------------------------------------------------------------------------------------------
# EXPOSE PORT - Expose default port at which the application will respond
#-----------------------------------------------------------------------------------------------------------------------
EXPOSE $SERVICE_PORT/tcp

#-----------------------------------------------------------------------------------------------------------------------
# Basic files for boot
#-----------------------------------------------------------------------------------------------------------------------
COPY ./samples/query/create.user.sql /samples/query/create.user.sql
COPY ./scripts /scripts


#-----------------------------------------------------------------------------------------------------------------------
# ENTRYPOINT
#-----------------------------------------------------------------------------------------------------------------------
COPY ./docker/n8n/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]