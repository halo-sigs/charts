# Halo Helm Chart

用于部署 [Halo](https://github.com/halo-dev/halo) 的 Helm Chart。

目前仅支持自动安装 PostgreSQL，需要使用其他类型的数据库可以通过指定 `externalDatabase.host` 等参数使用已有数据库。

## 使用指引

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add halo https://halo-sigs.github.io/charts/
helm repo update  # 从 chart 仓库中更新本地可用chart的信息
helm install halo halo/halo
```

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`           | Labels to add to all deployed resources                                                      | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed resources                                                 | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            | `["infinity"]`  |

### Halo Image parameters

| Name                | Description                                                                                          | Value          |
| ------------------- | ---------------------------------------------------------------------------------------------------- | -------------- |
| `image.registry`    | Halo image registry                                                                                  | `docker.io`    |
| `image.repository`  | Halo image repository                                                                                | `halohub/halo` |
| `image.tag`         | Halo image tag (immutable tags are recommended)                                                      | `2.19.0`       |
| `image.digest`      | Halo image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`           |
| `image.pullPolicy`  | Halo image pull policy                                                                               | `IfNotPresent` |
| `image.pullSecrets` | Halo image pull secrets                                                                              | `[]`           |

### Halo Configuration parameters

| Name                 | Description                                                          | Value                   |
| -------------------- | -------------------------------------------------------------------- | ----------------------- |
| `haloExternalUrl`    | 外部访问地址，请根据实际需要修改                                                     | `http://localhost:8090` |
| `haloScheme`         | Scheme to use to generate Halo URLs                                  | `http`                  |
| `command`            | Override default container command (useful when using custom images) | `[]`                    |
| `args`               | Override default container args (useful when using custom images)    | `[]`                    |
| `extraEnvVars`       | Array with extra environment variables to add to the Halo container  | `[]`                    |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                 | `""`                    |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                    | `""`                    |

### Database Parameters

| Name                                          | Description                                                                       | Value        |
| --------------------------------------------- | --------------------------------------------------------------------------------- | ------------ |
| `postgresql.enabled`                          | Deploy a PostgreSQL server to satisfy the applications database requirements      | `true`       |
| `postgresql.architecture`                     | PostgreSQL architecture. Allowed values: `standalone` or `replication`            | `standalone` |
| `postgresql.auth.rootPassword`                | PostgreSQL root password                                                          | `""`         |
| `postgresql.auth.database`                    | PostgreSQL custom database                                                        | `halo`       |
| `postgresql.auth.username`                    | PostgreSQL custom user name                                                       | `halo`       |
| `postgresql.auth.password`                    | PostgreSQL custom user password                                                   | `""`         |
| `postgresql.primary.persistence.enabled`      | Enable persistence on PostgreSQL using PVC(s)                                     | `true`       |
| `postgresql.primary.persistence.storageClass` | Persistent Volume storage class                                                   | `""`         |
| `postgresql.primary.persistence.accessModes`  | Persistent Volume access modes                                                    | `[]`         |
| `postgresql.primary.persistence.size`         | Persistent Volume size                                                            | `8Gi`        |
| `mysql.enabled`                               | Deploy a MySQL server to satisfy the applications database requirements           | `false`      |
| `mysql.architecture`                          | MySQL architecture. Allowed values: `standalone` or `replication`                 | `standalone` |
| `mysql.auth.rootPassword`                     | MySQL root password                                                               | `""`         |
| `mysql.auth.database`                         | MySQL custom database                                                             | `halo`       |
| `mysql.auth.username`                         | MySQL custom user name                                                            | `halo`       |
| `mysql.auth.password`                         | MySQL custom user password                                                        | `""`         |
| `mysql.primary.persistence.enabled`           | Enable persistence on MySQL using PVC(s)                                          | `true`       |
| `mysql.primary.persistence.storageClass`      | Persistent Volume storage class                                                   | `""`         |
| `mysql.primary.persistence.accessModes`       | Persistent Volume access modes                                                    | `[]`         |
| `mysql.primary.persistence.size`              | Persistent Volume size                                                            | `8Gi`        |
| `externalDatabase.platform`                   | External Database platform                                                        | `postgresql` |
| `externalDatabase.host`                       | External Database server host                                                     | `""`         |
| `externalDatabase.port`                       | External Database server port                                                     | `""`         |
| `externalDatabase.user`                       | External Database username                                                        | `""`         |
| `externalDatabase.password`                   | External Database user password                                                   | `""`         |
| `externalDatabase.database`                   | External Database database name                                                   | `""`         |
| `externalDatabase.existingSecret`             | The name of an existing secret with database credentials. Evaluated as a template | `""`         |

### Halo deployment parameters

| Name                                                | Description                                                                                                              | Value           |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `replicaCount`                                      | Number of Halo replicas to deploy                                                                                        | `1`             |
| `updateStrategy.type`                               | Halo deployment strategy type                                                                                            | `RollingUpdate` |
| `updateStrategy.rollingUpdate`                      | Halo deployment rolling update configuration parameters                                                                  | `{}`            |
| `schedulerName`                                     | Alternate scheduler                                                                                                      | `""`            |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`            |
| `priorityClassName`                                 | Name of the existing priority class to be used by Halo pods, priority class needs to be created beforehand               | `""`            |
| `hostAliases`                                       | Halo pod host aliases                                                                                                    | `[]`            |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Halo pods                                                        | `[]`            |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Halo container(s)                                           | `[]`            |
| `sidecars`                                          | Add additional sidecar containers to the Halo pod                                                                        | `[]`            |
| `initContainers`                                    | Add additional init containers to the Halo pods                                                                          | `[]`            |
| `podLabels`                                         | Extra labels for Halo pods                                                                                               | `{}`            |
| `podAnnotations`                                    | Annotations for Halo pods                                                                                                | `{}`            |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`            |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`          |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`            |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                    | `""`            |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`            |
| `affinity`                                          | Affinity for pod assignment                                                                                              | `{}`            |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                           | `{}`            |
| `tolerations`                                       | Tolerations for pod assignment                                                                                           | `[]`            |
| `resources.limits`                                  | The resources limits for the Halo containers                                                                             | `{}`            |
| `resources.requests.memory`                         | The requested memory for the Halo containers                                                                             | `512Mi`         |
| `resources.requests.cpu`                            | The requested cpu for the Halo containers                                                                                | `300m`          |
| `containerPorts.http`                               | Halo HTTP container port                                                                                                 | `8090`          |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Halo container(s)                                                  | `[]`            |
| `podSecurityContext.enabled`                        | Enabled Halo pods' Security Context                                                                                      | `true`          |
| `podSecurityContext.fsGroup`                        | Set Halo pod's Security Context fsGroup                                                                                  | `1001`          |
| `containerSecurityContext.enabled`                  | Enabled Halo containers' Security Context                                                                                | `true`          |
| `containerSecurityContext.runAsUser`                | Set Halo container's Security Context runAsUser                                                                          | `1001`          |
| `containerSecurityContext.runAsNonRoot`             | Set Halo container's Security Context runAsNonRoot                                                                       | `true`          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Halo container's privilege escalation                                                                                | `false`         |
| `containerSecurityContext.capabilities.drop`        | Set Halo container's Security Context runAsNonRoot                                                                       | `["ALL"]`       |
| `livenessProbe.enabled`                             | Enable livenessProbe on Halo containers                                                                                  | `true`          |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `30`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`            |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`             |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `3`             |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`             |
| `readinessProbe.enabled`                            | Enable readinessProbe on Halo containers                                                                                 | `true`          |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `30`            |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`            |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`             |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `3`             |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`             |
| `startupProbe.enabled`                              | Enable startupProbe on Halo containers                                                                                   | `false`         |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `10`            |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `5`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `3`             |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `3`             |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`             |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`            |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`            |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`            |
| `lifecycleHooks`                                    | for the Halo container(s) to automate configuration before or after startup                                              | `{}`            |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Halo service type                                                                                                                | `NodePort`               |
| `service.ports.http`               | Halo service HTTP port                                                                                                           | `80`                     |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | Halo service Cluster IP                                                                                                          | `""`                     |
| `service.loadBalancerIP`           | Halo service Load Balancer IP                                                                                                    | `""`                     |
| `service.loadBalancerSourceRanges` | Halo service Load Balancer sources                                                                                               | `[]`                     |
| `service.externalTrafficPolicy`    | Halo service external traffic policy                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Halo service                                                                                   | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Halo service                                                                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Halo                                                                                        | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `halo.local`             |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Persistence Parameters

| Name                                                   | Description                                                                                                   | Value                   |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `persistence.enabled`                                  | Enable persistence using Persistent Volume Claims                                                             | `true`                  |
| `persistence.storageClass`                             | Persistent Volume storage class                                                                               | `""`                    |
| `persistence.accessModes`                              | Persistent Volume access modes                                                                                | `[]`                    |
| `persistence.size`                                     | Persistent Volume size                                                                                        | `10Gi`                  |
| `persistence.dataSource`                               | Custom PVC data source                                                                                        | `{}`                    |
| `persistence.existingClaim`                            | The name of an existing PVC to use for persistence                                                            | `""`                    |
| `persistence.selector`                                 | Selector to match an existing Persistent Volume for Halo data PVC                                             | `{}`                    |
| `persistence.annotations`                              | Persistent Volume Claim annotations                                                                           | `{}`                    |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`               | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                                  | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                                | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                                      | `11-debian-11-r59`      |
| `volumePermissions.image.digest`                       | Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                              | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                                   | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                                | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | User ID for the init container                                                                                | `0`                     |

### Other Parameters

| Name                                          | Description                                                            | Value   |
| --------------------------------------------- | ---------------------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Halo pod                         | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |

### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                  | Value   |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                      | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                               | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                       | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                   | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                    | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.                | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                            | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (postgresql) only accessible by testlink's pods.                                  | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                             | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes testlink only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access testlink. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access testlink. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                           | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                               | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                   | `{}`    |


## License

- 使用了 [Bitnami Charts 仓库](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)的 common 及 postgresql 作为依赖
- 在 [Bitnami Charts](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) 现有的 chart 基础上进行了修改
