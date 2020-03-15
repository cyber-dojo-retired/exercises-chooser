FROM nginx:latest
LABEL maintainer=jon@jaggersoft.com

ARG NGINX_DIR=/usr/share/nginx/html
COPY js     ${NGINX_DIR}/js
RUN chmod -R +r ${NGINX_DIR}

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN echo ${SHA} > ${NGINX_DIR}/sha.txt
