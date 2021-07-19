# Minecraft Velocity Server Proxy for Docker

This project creates a [Velocity](https://velocitypowered.com/) Minecraft server proxy in a Docker container, for the purposes of connecting multiple containerized Minecraft servers together.  The Docker container can be used directly with Docker or using an orchestration system like Kubernetes.

## Getting Started

You need two things to get started: the Docker image generated from this repository, and a [`velocity.toml`](https://velocitypowered.com/wiki/users/configuration/).  A default `velocity.toml` has been added to the image, but the server list will not be correct for you.  Instead, volume-mount your `velocity.toml` to `/velocity/velocity.toml` in the Docker container.

### Docker

Assuming your `velocity.toml` is in your current directory:

```
docker run -v velocity.toml:/velocity/velocity.toml ghcr.io/cadwallion/mc-velocity:3.0.0`
```

### Kubernetes

This example uses a [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) to bind the `velocity.toml`  into the running container in a Kubernetes Deployment.  This means your config file needs to live on the same physical host as where the pod is scheduled.  This is fine for example purposes, but it is suggested that either this config be put in a [configMap](https://kubernetes.io/docs/concepts/storage/volumes/#configmap):

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mc-velocity
spec:
  selector:
    matchLabels:
      app: mc-velocity
  replicas: 1
  template:
    metadata:
      labels:
        app: mc-velocity
    spec:
      containers:
      - name: mc-velocity
        image: ghcr.io/cadwallion/mc-velocity:3.0.0
        ports:
        - containerPort: 25577
        volumeMounts:
        - name: config-volume
          mountPath: /velocity/velocity.toml
          subPath: velocity.toml
      imagePullSecrets:
      - name: ghcr
      volumes:
      - name: config-volume
        hostPath:
          # Directory on host
          path: /data/minecraft/velocity.toml
```
