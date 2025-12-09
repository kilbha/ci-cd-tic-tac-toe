## ECR settings for kind

# Login to ECR from your local machine
```bash
aws ecr get-login-password --region ap-south-2 \
  | docker login \
    --username AWS \
    --password-stdin 045555583762.dkr.ecr.ap-south-2.amazonaws.com
```

```bash
docker pull 045555583762.dkr.ecr.ap-south-2.amazonaws.com/go-web-app:latest
```

# 2 Create a Kubernetes Secret for pulling ECR images

```bash
kubectl create secret docker-registry ecr-regcred \
  --docker-server=045555583762.dkr.ecr.ap-south-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password="$(aws ecr get-login-password --region ap-south-2)" \
  --docker-email=fake@example.com
```

```bash
kubectl get secret ecr-regcred
```

# 3 Add the secret to your Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: go-web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: go-web-app
  template:
    metadata:
      labels:
        app: go-web-app
    spec:
      containers:
      - name: go-web-app
        image: 045555583762.dkr.ecr.ap-south-2.amazonaws.com/go-web-app:latest
      imagePullSecrets:
      - name: ecr-regcred
```

# GET IPADDRESS Kind Cluster Node

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-control-plane
```