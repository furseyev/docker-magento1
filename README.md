# docker-magento1

Opinionated Magento 1 docker image.

## Base image

 - Alpine 3.8

## Included software

 - NGINX
 - php-fpm

## Extra bits

 - Node.js
 - Redis
 - Ruby
 - runit
 - sassc

## Getting started

```sh-session
# Build image
$ rake build

# Test image
# Visit http://localhost:3000/
$ rake test
```
