#!/bin/bash

# 先取得 Pi 金流微服務的 laradock workspace ContainerId
WORKSPACE_DOCKER_CONTAINER_ID=$(docker ps | grep "laradock-qa-workspace" | awk '{print $1;}')

# 綁定 workspace 和 mongodb & redis 的網路
 docker network disconnect laradock-database-default $WORKSPACE_DOCKER_CONTAINER_ID || true
 docker network connect laradock-database-default $WORKSPACE_DOCKER_CONTAINER_ID || true

# 先取得 Pi 金流微服務的 laradock php-fpm ContainerId
PHPFPM_DOCKER_CONTAINER_ID=$(docker ps | grep "laradock-qa-php-fpm" | awk '{print $1;}')

# 綁定 php-fpm 和 mongodb & redis 的網路
 docker network disconnect laradock-database-default $PHPFPM_DOCKER_CONTAINER_ID || true
 docker network connect laradock-database-default $PHPFPM_DOCKER_CONTAINER_ID || true

