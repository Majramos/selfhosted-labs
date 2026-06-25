# Self-Hosted Labs

Scripts and containers to setup my computer / developement environment / homelab

## Sites for Self-Hosted Tools
- [hostedsoftware](https://hostedsoftware.org/)

## systemctl shortcuts
```
systemctl --user daemon-reload

systemctl --user enable --now n8n.service
systemctl --user status n8n.service

systemctl --user start n8n-postgres.service
systemctl --user start n8n-runner.service
systemctl --user start n8n.service

# access logs
journalctl --user -xeu n8n.service

# check existing .service files
ls /run/user/$(id -u)/systemd/generator/

```

## Services

### restart podman
- https://linuxhandbook.com/autostart-podman-containers/
- https://qubitsandbytes.co.uk/containers/running-podman-pods-and-containers-on-boot/
```bash
mkdir -p ~/.config/systemd/user
```

### network
create a network to connect all containers and use a reverse proxy

```bash
$ docker network create reverse_proxy
```

add `127.0.0.1 local.lab` to hosts file

- Linux `/etc/hosts`
- Windows `C:\Windows\System32\drivers\etc\hosts`
- Mac `/private/etc/hosts`

### Caddy
reverse proxy

Site:
- https://caddyserver.com/

Documentation on docker instalation:
- https://linuxiac.com/how-to-set-up-caddy-as-reverse-proxy/#h-set-up-caddy-as-a-reverse-proxy-in-a-docker-container
- https://linuxconfig.org/how-to-bind-a-rootless-container-to-a-privileged-port-on-linux
- https://serverfault.com/questions/1004701/firewall-cmd-not-allowing-loopback-redirect/1004742#1004742
- https://linuxhandbook.com/firewalld-cmd/

#### fix for `cannot expose privileged port 80`
with --permanent, to make it permanent
```bash
$ sudo firewall-cmd --direct --add-rule ipv4 nat OUTPUT 0 -p tcp --dport=80 -o lo -j REDIRECT --to-port=8080
$ sudo firewall-cmd --reload
```

```bash
$ docker compose -f $PWD/caddy/compose.yaml up -d
```
enter container in root mode
```bash
$ podman exec -it -u root reverse_proxy_caddy sh
```
reload caddy config
```bash
$ caddy reload --config /etc/caddy/Caddyfile
```

#### autostart on boot
```bash
$ podman generate systemd --new --name reverse_proxy_caddy
```


### Portainer
container management

Site:
- https://www.portainer.io/

Documentation on docker instalation:
- https://docs.portainer.io/start/install-ce/server/docker/linux
- https://linuxtldr.com/deploy-portainer-on-podman/#Step_22_Deploying_the_Portainer_Server_on_Podman_without_Root

fix for podman, enable for rootless
```bash
$ systemctl --user enable --now podman.socket
```
run container
```bash
$ podman compose --podman-run-args='--security-opt label=disable' up
# or
$ podman compose --podman-run-args='--privileged' up
# $ docker compose -f $PWD/portainer/compose.yaml up -d
```

#### enable start of system services, even if not logged in
```bash
sudo loginctl enable-linger $USER
``

### SearXNG
meta-search engine

Site:
- https://github.com/searxng/searxng
- https://github.com/searxng/searxng-docker

Documentation on docker instalation:
- https://docs.searxng.org/admin/installation-docker.html

Setup browser search
- https://<host ip>/?q=%s

```bash
$ docker compose -f .\searxng\compose.yaml up -d
```

### IT-Tools
general tools

Site:
- https://github.com/CorentinTh/it-tools

Documentation on docker instalation:
- https://github.com/CorentinTh/it-tools/pull/461

```bash
$ docker compose -f .\it-tools\compose.yaml up -d
```

### Stirling-PDF
general tools

Site:
- https://www.stirlingpdf.com/

Documentation on docker instalation:
- https://github.com/Stirling-Tools/Stirling-PDF

```bash
$ docker compose -f .\stirling-pdf\compose.yaml up -d
```

### Tasks.md
A self-hosted, Markdown file based task management board.

Site:
- https://github.com/BaldissaraMatheus/Tasks.md

Documentation on docker instalation:
- https://github.com/BaldissaraMatheus/Tasks.md?tab=readme-ov-file#-installation

```bash
$ docker compose -f .\tasks.md\compose.yaml up -d
```

### Homepage
application dashboard

Site:
- https://gethomepage.dev/

Documentation on docker instalation:
- https://gethomepage.dev/installation/docker/

```bash
$ docker compose -f .\homepage\compose.yaml up -d
```

### uptime-kuma

Site:
- https://uptimekuma.org/

```bash
$ docker compose -f .\uptime\compose.yaml up -d
```

### Actual Budget

Site:
- https://actualbudget.org/

```bash
$ docker compose -f ./actualbudget/compose.yaml up -d
```

## Utilities
```console
$ podman inspect <container name> --format '{{ .State.Status }}'
```


### Vikunja
project management

Site:
- https://vikunja.io/

Documentation on docker instalation:
- https://vikunja.io/docs/docker-walkthrough

```bash
$ docker compose -f ./vikunja/compose.yaml up -d
```

### readeck
bookmark

Site:
- https://readeck.org/

Documentation on docker instalation:
- https://readeck.org/en/docs/compose

```bash
$ docker compose -f ./readeck/compose.yaml up -d
```

### traefik
reverse proxy

Site:
- https://traefik.io/

Documentation on docker instalation:
- https://doc.traefik.io/traefik/

```bash
$ docker compose -f ./traefik/compose.yaml up -d
```
