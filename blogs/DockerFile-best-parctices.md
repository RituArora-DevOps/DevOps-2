# Docker Best Practices for MERN Stack Projects

This guide outlines industry-standard best practices for Dockerizing a MERN (MongoDB, Express, React, Node) stack application. Following these recommendations helps ensure better scalability, portability, and maintainability across environments.

---

## 1. Use Separate Containers per Service

- **Frontend (React)**, **Backend (Node/Express)**, and **Database (MongoDB)** should each run in their own container.
- Manage them together using `docker-compose.yml`

> Benefit: Clean separation of concerns, easier to debug and scale

---

## 2. Keep Dockerfiles Clean and Efficient

### Backend Dockerfile Tips:

- Use `node:20-alpine` as base image for reduced size
- Install only required dependencies
- Use `.dockerignore` to exclude `node_modules`, logs, etc.

### Frontend Dockerfile Tips:

- Use multi-stage builds to separate build-time and runtime environments
- Serve React static build via NGINX in production

---

## 3. Use Environment Variables via `.env`

Do **not** hardcode values like port numbers or database URIs.

**Example `.env`**:

```
PORT=5000
MONGO_URI=mongodb://mongo:27017/todoapp
```

- Inject env vars via Compose or `dotenv`

---

## 4. Use Named Volumes for MongoDB

To persist data across container restarts:

```yaml
volumes:
  mongo-data:
```

```yaml
services:
  mongo:
    image: mongo
    volumes:
      - mongo-data:/data/db
```

> Ensures local MongoDB data is not lost on container shutdown

---

## 5. Expose Only Required Ports

- FE: expose port 3000
- BE: expose 5000 if needed (private in production)
- DB: avoid exposing MongoDB externally unless required for testing

---

## 6. Use `depends_on` in Compose

Ensure backend starts **after MongoDB**:

```yaml
services:
  backend:
    depends_on:
      - mongo
```

---

## 7. Optional: Add Health Checks

Health checks help orchestrators restart unhealthy containers.

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
  interval: 30s
  timeout: 10s
```

---

## 8. Use Bind Mounts Only in Dev

- In development, use bind mounts for hot-reloading:

```yaml
volumes:
  - .:/app
```

- In production, copy app files into the image at build time

---

## 9. Don’t Store Secrets in Code

- Use `.env`, `.env.production`, or Docker Secrets
- Never commit credentials or API keys to Git

---

## 10. Use `.dockerignore`

Exclude unnecessary files from the build context:

```
node_modules
logs
.env
.git
Dockerfile
docker-compose.yml
```

> Benefit: Reduces image size and speeds up build

---

## Suggested Workflow

| Environment | Tooling            | Best Practice                            |
| ----------- | ------------------ | ---------------------------------------- |
| Development | Docker Compose     | Use bind mounts, expose ports            |
| Testing     | Docker + CI Tools  | Run unit/integration tests in containers |
| Production  | Multi-stage builds | Serve FE via NGINX, BE as Node app       |
| Storage     | Docker Volumes     | Persist MongoDB data using named volumes |

---

This guide is part of a blog series on DevOpsifying a MERN To-Do app. Stay tuned for Dockerfile and `docker-compose.yml` examples in the next post.
