用于部署 [Halo](https://github.com/halo-dev/halo) 的 Helm Chart

## 使用指引

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add halo https://halo-dev.github.io/helm-chart/
helm repo update  # 从 chart 仓库中更新本地可用chart的信息
helm install halo halo/halo
```
