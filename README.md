# docker-magento1

Opinionated docker image for Magento 1.9.4+.

## Base image

 - Alpine 3.8

## Included software

 - nginx
 - php-fpm
 - Redis
 - MySQL client
 - msmtp, aliased as sendmail

## Extra bits

 - Node.js
 - runit
 - sassc
 - dockerize

## Getting started

```sh-session
# Build image
docker build -t furseyev/magento1 .

# Test image, visit http://127.0.0.1:8080/
cd /path/to/magento1/project
docker run --init --rm -p 80:80 -v $(pwd):/var/www/magento1 furseyev/magento1
```
