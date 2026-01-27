#!/usr/bin/env bash
set -e

name=$(npm pkg get name | tr -d '"')
version=$(npm pkg get version | tr -d '"')

# Port hôte par défaut (8080 est souvent pris chez toi), change si besoin
host_port="${1:-8082}"
container_port=8080

docker run --rm -p "${host_port}:${container_port}" --name "${name}" "${name}:${version}"
echo "OK => http://localhost:${host_port}"
