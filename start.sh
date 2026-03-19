#!/bin/bash

set -e

# Создаём папку для храние данных tarantool и устанавливаем права
mkdir -p ./data
sudo chown -R tarantool:tarantool ./data
sudo chmod -R 755 ./data

# Запускаем docker-compose
docker-compose up -d