#!/usr/bin/env bash

# choose container manager between docker and podman
function manager {
    podman "$@"
}

docker --version &> /dev/null
has_docker=$?
podman --version &> /dev/null
has_podman=$?

if [ $has_docker -eq 0 ] && [ $has_podman -eq 0 ]; then
    echo "Both Docker and Podman are available, using Podman"
elif [ $has_docker -eq 0 ] && [ $has_podman -gt 0 ]; then
    echo "Docker is available, using Docker"
    function manager {
        docker "$@"
    }
else
    echo "Podman is available, using Podman"
fi

manager --version

# TODO: add a loop to check for existing or running containers and remove the containers and volumes
# podman compose down -v
# NOTE: caddy has to be the last one to be removed because of network


# setup podman quadlet
quadlet_path=$HOME/.config/containers/systemd/
mkdir -p quadlet_path

mkdir -p /opt/containers/portainer/data

# setup main services
echo "starting caddy"
manager compose \
    --file $PWD/caddy/compose.yaml \
    up -d

# setup for portainer to work with podman
systemctl --user enable --now podman.socket

echo "starting portainer"
manager compose \
    --podman-run-args='--security-opt label=disable' \
    --file $PWD/portainer/compose.yaml \
    up -d

systemctl --user daemon-reload
systemctl --user start reverse_proxy_caddy.service
systemctl --user start portainer.service
systemctl --user start mynginx.service


# optional services

# manager compose \
#     --file $PWD/actualbudget/compose.yaml \
#     up


# actualbudget
mkdir -p $HOME/containers/actualbudget/data
manager compose \
    --file $PWD/actualbudget/compose.yaml \
    up -d
