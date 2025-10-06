# DevOps Internship Assessment - Next.js Application

This repository contains a simple Next.js application containerized with Docker, automated using GitHub Actions to push the image to GitHub Container Registry (GHCR), and deployed on Kubernetes using Minikube.

---

## 1. Setup Instructions

### 1.1 Install Prerequisites

Ensure you have the following installed:

1. **Node.js (v18+)**  
   - [Download Node.js](https://nodejs.org/) and install.

2. **npm** (comes with Node.js)

3. **Docker**  
   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop/) and install.
   - Start Docker Desktop.

4. **kubectl** (Kubernetes CLI)  
   ```bash
   # For Windows using Chocolatey
   choco install kubernetes-cli
Minikube

# For Windows using Chocolatey
choco install minikube
GitHub Account with access to create repositories and GitHub Actions secrets.

2. Local Run Commands
   # Clone Repository

git clone https://github.com/nikhilnamaji/wexaAI-assesment-nikhil-namaji.git
cd wexaAI-assesment-nikhil-namaji
2.2 Navigate to Next.js App

cd nextjs-app
2.3 Install Dependencies

npm install
2.4 Run App Locally

npm run dev
Open your browser and navigate to http://localhost:3000

You should see the running Next.js application.

2.5 Optional: Run Using Docker Locally

# Build Docker image
docker build -t nextjs-app:latest ./nextjs-app

# Run Docker container
docker run -p 3000:3000 nextjs-app:latest
Open browser at http://localhost:3000

3. Deployment Steps for Minikube
3.1 Start Minikube
   
minikube start
Ensure Minikube is running:


minikube status
3.2 Create Docker Registry Secret for GHCR
GitHub Container Registry (GHCR) requires authentication to pull images.


kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=nikhilnamaji \
  --docker-password=<YOUR_PERSONAL_ACCESS_TOKEN> \
  --docker-email=namaji.nik69@gmail.com
Replace <YOUR_PERSONAL_ACCESS_TOKEN> with your GitHub Personal Access Token with write:packages scope.

3.3 Update Deployment YAML (k8s/deployment.yaml)
Ensure your deployment file contains:

yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextjs-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nextjs-app
  template:
    metadata:
      labels:
        app: nextjs-app
    spec:
      containers:
        - name: nextjs-app
          image: ghcr.io/nikhilnamaji/nextjs-app:latest
          ports:
            - containerPort: 3000
      imagePullSecrets:
        - name: ghcr-secret
This ensures Kubernetes can pull your private image using the secret.

3.4 Create Service YAML (k8s/service.yaml)
yaml
apiVersion: v1
kind: Service
metadata:
  name: nextjs-service
spec:
  type: NodePort
  selector:
    app: nextjs-app
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
      nodePort: 30001
3.5 Apply Kubernetes Manifests

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
Verify pods and service:

kubectl get pods
kubectl get svc
Pods should show Running.

4. Accessing the Deployed Application
4.1 Get Service URL from Minikube
   
minikube service nextjs-service --url
This command will return a URL like http://127.0.0.1:58977

Open this URL in your browser to access the deployed Next.js app.

5. GitHub Actions CI/CD
Workflow (.github/workflows/ci.yaml) automatically:

Builds the Docker image on push to main.

Pushes the image to GitHub Container Registry (GHCR).

Uses the secret GHCR_PAT for authentication.

Docker image URL: ghcr.io/nikhilnamaji/nextjs-app:latest (public)

Notes / Observations:

Initial ErrImagePull error happened because GHCR required a PAT.

Deployment selector is immutable; changes required deleting the deployment before re-applying.

Multi-stage Docker build could be used to optimize image size for production.

6. References
Next.js Documentation

Docker Documentation

Kubernetes Documentation

Minikube Documentation
