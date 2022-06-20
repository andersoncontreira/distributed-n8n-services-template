FROM nginx:alpine
MAINTAINER Anderson Contreira <anderson.contreira@gmail.com>
#-----------------------------------------------------------------------------------------------------------------------
# ARGS Provided by user, weather from buildspec or docker-compose file
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#-----------------------------------------------------------------------------------------------------------------------
ARG DEFAULT_PORT=80
ARG SERVER_NAME=_
ARG CONTAINER_HOST=0.0.0.0
ARG CONTAINER_PORT=5678


RUN apk add --no-cache sed

COPY docker/nginx/confs/nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i "s/{DEFAULT_PORT}/$DEFAULT_PORT/" /etc/nginx/conf.d/default.conf \
 && sed -i "s/{SERVER_NAME}/$SERVER_NAME/" /etc/nginx/conf.d/default.conf \
 && sed -i "s/{CONTAINER_HOST}/$CONTAINER_HOST/" /etc/nginx/conf.d/default.conf \
 && sed -i "s/{CONTAINER_PORT}/$CONTAINER_PORT/" /etc/nginx/conf.d/default.conf