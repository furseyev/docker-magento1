FROM alpine:3.8
LABEL maintainer="Tom Richards <tom.r@delegator.com>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="delegator/magento1"
LABEL org.label-schema.description="Opinionated docker image for Magento 1.9.4+."
LABEL org.label-schema.vcs-url="https://github.com/delegator/docker-magento1"

# Install packages
RUN apk add --update --no-cache \
  php7 php7-bcmath php7-ctype php7-curl php7-dom php7-fileinfo php7-fpm php7-gd php7-iconv php7-intl php7-mbstring php7-mysqli php7-opcache php7-pdo_mysql php7-redis php7-session php7-simplexml php7-soap php7-tokenizer php7-xsl php7-xml php7-xmlwriter php7-zip \
  composer php7-xdebug \
  nginx nginx-mod-http-headers-more \
  bash runit \
  curl htop git libxml2-utils make openssh vim \
  mysql-client redis \
  nodejs sassc yarn \
  msmtp \
  procps patch

# Configure msmtp
RUN unlink /usr/sbin/sendmail \
 && ln -s /usr/bin/msmtp /usr/sbin/sendmail

# Add non-privileged web server user
# Configure nginx and php
ENV PHP_LOG_STREAM="/var/log/php.log"
RUN deluser xfs \
 && delgroup www-data \
 && addgroup -S -g 33 www-data \
 && adduser -S -D -u 33 -G www-data -h /var/www -s /bin/bash www-data \
 && chown -R www-data:www-data /var/tmp/nginx \
 && rm -f /etc/nginx/conf.d/default.conf \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && mkfifo -m 777 $PHP_LOG_STREAM

# Install prestissimo for parallel composer downloads
USER www-data
RUN composer global require hirak/prestissimo \
 && rm -rf /var/www/.composer/cache
USER root
RUN composer global require hirak/prestissimo \
 && rm -rf /root/.composer/cache

# n98-magerun for Magento 1
ENV MAGERUN_VERSION 1.102.0
RUN curl -sL https://files.magerun.net/n98-magerun-$MAGERUN_VERSION.phar -o /usr/local/bin/n98-magerun \
 && chmod +x /usr/local/bin/n98-magerun \
 && n98-magerun --version

# Install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && dockerize -version

# Install config files and tester site
COPY ./config/nginx /etc/nginx
COPY ./config/php7 /etc/php7
COPY ./config/services /services

# Test nginx configuration
RUN /usr/sbin/nginx -T

# Set working directory
RUN mkdir -p /var/www/magento1 \
 && chown -R www-data:www-data /var/www
WORKDIR /var/www/magento1

# Default command; run nginx and php-fpm services
CMD ["/sbin/runsvdir", "/services"]

# Expose ports
EXPOSE 8080
