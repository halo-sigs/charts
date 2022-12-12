# Halo Helm Chart

用于部署 [Halo](https://github.com/halo-dev/halo) 的 Helm Chart。

目前仅支持自动安装 PostgreSQL，需要使用其他类型的数据库可以通过指定 `externalDatabase.host` 等参数使用已有数据库。

## 使用指引

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add halo https://halo-sigs.github.io/helm-chart/
helm repo update  # 从 chart 仓库中更新本地可用chart的信息
helm install halo halo/halo
```
