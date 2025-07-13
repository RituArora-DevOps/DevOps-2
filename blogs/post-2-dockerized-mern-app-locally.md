---

title: "Post 2: Containerization, Health Checks, and Debugging"
date: 2025-07-11
description: "Dockerizing the MERN To-Do App, adding production health checks, and debugging service communication"
-------------------------------------------------------------------------------------------------------------------

## Summary

This post covers the second major milestone in our MERN To-Do App DevOps journey. We:

* Dockerized the backend and frontend using Dockerfiles
* Used Docker Compose to orchestrate MongoDB, backend, and frontend
* Added health and readiness checks to the backend
* Refactored backend into modular `server.js`, `db.js`, and `routes/health.js`
* Faced and resolved service resolution issues (`localhost` vs `container_name`)
* Discussed environment variable management, database authentication, and volume persistence

---

## Dockerization

### Frontend `Dockerfile`

We used a multi-stage build:

```Dockerfile
# Stage 1: React build
FROM node:20 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Nginx serving
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Backend `Dockerfile`

```Dockerfile
FROM node:20
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["node", "server.js"]
```

### `docker-compose.yml`

```yaml
version: "3.8"
services:
  mongo:
    image: mongo
    container_name: todo-mongo
    ports:
      - 27017:27017
    volumes:
      - mongo-data:/data/db

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: todo-backend
    ports:
      - 5000:5000
    env_file:
      - ./backend/.env
    volumes:
      - ./backend:/app
    depends_on:
      - mongo

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: todo-frontend
    ports:
      - 3000:3000
    volumes:
      - ./frontend:/app
    depends_on:
      - backend

volumes:
  mongo-data:
```

## Health and Readiness Checks

Added `/healthz` and `/readyz` endpoints under `routes/health.js`:

```js
// routes/health.js
const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");

router.get("/healthz", (req, res) => {
  res.status(200).send("Healthy");
});

router.get("/readyz", async (req, res) => {
  try {
    await mongoose.connection.db.admin().ping();
    res.status(200).send("Ready");
  } catch (err) {
    console.error("Readiness failed:", err.message);
    res.status(503).send("Not ready");
  }
});

module.exports = router;
```

Hooked into `server.js` using:

```js
app.use("/", require("./routes/health"));
```

## Refactor: `db.js`

Moved MongoDB logic into `db.js`:

```js
const mongoose = require("mongoose");

module.exports = async () => {
  try {
    const connectionParams = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    };
    if (process.env.USE_DB_AUTH === "true") {
      connectionParams.user = process.env.MONGO_USERNAME;
      connectionParams.pass = process.env.MONGO_PASSWORD;
    }
    await mongoose.connect(process.env.MONGO_CONN_STR, connectionParams);
    console.log("Connected to database.");
  } catch (err) {
    console.error("DB connection error:", err);
  }
};
```

## Frontend Debugging: Axios URL Issue

In `App.js`, we initially used:

```js
const API_URL = "http://localhost:5000/api/todos";
```

But inside Docker, frontend container must access backend by **container name**:

```js
const API_URL = "http://todo-backend:5000/api/todos";
```

Alternatively, in local development you can use environment variables in `.env`:

```env
REACT_APP_API_URL=http://localhost:5000/api/todos
```

Access in code via `process.env.REACT_APP_API_URL`

## Testing Containers

- `docker-compose up --build`
- Check: `curl http://localhost:5000/healthz` and `readyz`
- Use logs: `docker-compose logs -f backend`

Frontend should be accessible at:

```
http://localhost:3000
```

If it’s blank, confirm the React app built properly and was copied into Nginx in the final stage.

## Volumes

```yaml
volumes:
  - mongo-data:/data/db # This is created on the host by Docker under /var/lib/docker/volumes/
```

This persists MongoDB data between container restarts.

## Conclusion

We’ve made our app containerized and added basic production-readiness with health checks. Next steps include:

- CI/CD (GitHub Actions)
- Hosting on AWS with Kubernetes
- Adding observability: logging, metrics, alerts

**Stay tuned for Post 3!**
