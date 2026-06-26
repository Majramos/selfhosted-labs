# monitoring

For node-exporter to work make. sure to to install first
```bash
apt install lm-sensors && sudo sensors-detect
```

## confirm prometheus configuration
podman exec -it prometheus cat /etc/prometheus/prometheus.yml

## setup grafana
After it starts, in Grafana go to Connections → Data Sources → Add Prometheus and point it at http://localhost:9090. For dashboards, import these community IDs:
1860 — Node Exporter Full (host metrics + CPU temps)
21559 — Podman Exporter Dashboard (container metrics

## sources
- https://dev.to/rafi021/how-to-set-up-a-monitoring-stack-with-prometheus-grafana-and-node-exporter-using-docker-compose-17cc
- https://oneuptime.com/blog/post/2026-01-25-prometheus-node-exporter/view
