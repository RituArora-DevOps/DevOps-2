# Building a Simple To-Do App with the MERN Stack

> A beginner-friendly tutorial to build a full-stack to-do app using MongoDB (Docker), Express, React, and Node.js

---

## What We'll Build

A simple full-stack to-do list where users can:

- Add a task
- Mark it as completed
- Delete it

---

## Tech Stack

- **MongoDB** (Docker container)
- **Express.js** (REST API)
- **React** (Create React App)
- **Node.js** (Backend runtime)

---

## Prerequisites

- Node.js & npm
- Docker installed and running

---

## Step 1: Set Up MongoDB Using Docker

```bash
docker run -d \
  --name todo-mongo \
  -p 27017:27017 \
  mongo
```

> This starts a local MongoDB container accessible at `mongodb://localhost:27017`

---

## Step 2: Backend with Express + MongoDB

### 1. Create backend folder

```bash
mkdir backend && cd backend
npm init -y
```

### 2. Install dependencies

```bash
npm install express mongoose cors dotenv
```

### 3. Folder structure

```
backend/
├── models/
│   └── Todo.js
├── routes/
│   └── todos.js
├── .env
└── server.js
```

### 4. `.env` file

```
MONGO_URI=mongodb://localhost:27017/todoapp
```

### 5. `models/Todo.js`

```js
const mongoose = require("mongoose");

const TodoSchema = new mongoose.Schema({
  text: { type: String, required: true },
  isDone: { type: Boolean, default: false },
});

module.exports = mongoose.model("Todo", TodoSchema);
```

### 6. `routes/todos.js`

```js
const express = require("express");
const router = express.Router();
const Todo = require("../models/Todo");

router.get("/", async (req, res) => {
  const todos = await Todo.find();
  res.json(todos);
});

router.post("/", async (req, res) => {
  const todo = new Todo({ text: req.body.text });
  const saved = await todo.save();
  res.json(saved);
});

router.put(":id", async (req, res) => {
  const updated = await Todo.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  });
  res.json(updated);
});

router.delete(":id", async (req, res) => {
  await Todo.findByIdAndDelete(req.params.id);
  res.json({ message: "Deleted" });
});

module.exports = router;
```

### 7. `server.js`

```js
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

app.use("/api/todos", require("./routes/todos"));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

Start backend:

```bash
node server.js
```

---

## Step 3: Frontend with React

### 1. Create frontend app using CRA

```bash
npx create-react-app frontend
cd frontend
npm install axios
```

### 2. Folder structure

```
frontend/
├── public/
├── src/
│   ├── App.js
│   ├── index.js
│   └── ...
```

### 3. `src/App.js`

```jsx
import { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "http://localhost:5000/api/todos";

function App() {
  const [todos, setTodos] = useState([]);
  const [newTask, setNewTask] = useState("");

  useEffect(() => {
    axios.get(API_URL).then((res) => setTodos(res.data));
  }, []);

  const addTodo = () => {
    axios.post(API_URL, { text: newTask }).then((res) => {
      setTodos([...todos, res.data]);
      setNewTask("");
    });
  };

  const toggleDone = (id, current) => {
    axios.put(`${API_URL}/${id}`, { isDone: !current }).then((res) => {
      setTodos(todos.map((t) => (t._id === id ? res.data : t)));
    });
  };

  const deleteTodo = (id) => {
    axios.delete(`${API_URL}/${id}`).then(() => {
      setTodos(todos.filter((t) => t._id !== id));
    });
  };

  return (
    <div>
      <h1>To-Do App</h1>
      <input value={newTask} onChange={(e) => setNewTask(e.target.value)} />
      <button onClick={addTodo}>Add</button>
      <ul>
        {todos.map((todo) => (
          <li
            key={todo._id}
            style={{ textDecoration: todo.isDone ? "line-through" : "" }}
          >
            {todo.text}
            <button onClick={() => toggleDone(todo._id, todo.isDone)}>✔</button>
            <button onClick={() => deleteTodo(todo._id)}>🗑</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
```

Start frontend:

```bash
npm start
```

---

## Connecting It All

- Backend runs on: `http://localhost:5000`
- Frontend runs on: `http://localhost:3000`

Make sure **CORS** is enabled in Express so frontend can access the backend.

---

## Final Result

- Add, check, and delete tasks
- Backend persists them in MongoDB via Docker

---

## Next Post Preview

In the next tutorial, we’ll **Dockerize the backend and frontend** for container-based development and deployment.

---

## Wrap-Up

You now have a working full-stack MERN app with persistent storage in a Dockerized MongoDB! This is your launchpad for DevOps, CI/CD, and cloud deployments.

Stay tuned for the next post!
