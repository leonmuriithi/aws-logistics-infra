# ☁️ AWS Logistics Infrastructure (IaC)

Configuration files for deploying the logistics ecosystem on AWS EC2 instances using Docker Compose and Nginx Reverse Proxy.

## 🏗️ Stack
- **Containerization:** Docker & Docker Compose
- **Orchestration:** Docker Swarm (Manager/Worker Nodes)
- **Database:** PostgreSQL 15 (Master-Slave Replication)
- **Caching:** Redis Cluster for session management and seat locking.
- **Security:** SSL Termination via Nginx / Let's Encrypt.

## 🚀 Deployment Strategy
The pipeline utilizes **GitHub Actions** to build images and push to ECR, followed by a rolling update on the production cluster.

---
*Status: Configuration & Scripts*
