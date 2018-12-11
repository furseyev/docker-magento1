# docker-magento1

Opinionated Magento 1 docker image.

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
docker build -t delegator/magento1 .

# Test image, visit http://127.0.0.1/
cd /path/to/magento1/project
docker run --init --rm -p 80:80 -v $(pwd):/var/www/magento1 delegator/magento1
```
