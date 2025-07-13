# Post 1: MERN To-Do App – Detailed Explanation & Debug Log

## Overview

This document explains how the MERN To-Do App works and provides background for all questions, errors, and learning steps that came up during development.

---

## Backend Explanations

### MongoDB Connection with Docker

* **MongoDB is run inside Docker** using this command:

  ```bash
  docker run -d --name todo-mongo -p 27017:27017 mongo
  ```
* The backend connects to this container via:

  ```env
  MONGO_URI=mongodb://localhost:27017/todoapp
  ```

  * `todoapp` is the database name that MongoDB will create on-the-fly when data is inserted.
  * [MongoDB URI Format](https://www.mongodb.com/docs/manual/reference/connection-string/)

### Mongoose Methods

* `Todo.find()` – fetches all documents in the `todos` collection
* `new Todo({...}).save()` – creates and saves a new document
* `Todo.findByIdAndUpdate(id, data, {new: true})` – updates a document by ID and returns the updated document
* `Todo.findByIdAndDelete(id)` – deletes a document by ID
* [Mongoose Query API Docs](https://mongoosejs.com/docs/queries.html)

### `_id` in MongoDB

* MongoDB generates a unique `_id` field for each document
* This is why we use `todo._id` in React to uniquely identify and render each list item
* [MongoDB \_id Field](https://www.mongodb.com/docs/manual/core/document/#the-_id-field)

---

## Frontend Explanations

### `.map()` usage

In `App.js`, we render the list using:

```jsx
{todos.map(todo => (
  <li key={todo._id}>{todo.text}</li>
))}
```

* `.map()` iterates over the array `todos`
* Each `todo` is an object like `{ _id: 'abc123', text: 'Buy milk', isDone: false }`
* `key={todo._id}` is necessary for React’s reconciliation
* [React Lists and Keys](https://reactjs.org/docs/lists-and-keys.html)

### Input Field Behavior

```jsx
<input value={newTask} onChange={(e) => setNewTask(e.target.value)} />
```

* This binds the text box to state `newTask`
* Each keystroke updates the state
* [React Forms](https://reactjs.org/docs/forms.html)

---

## Error Handling Walkthrough

### 1. Missing `express` module

```bash
Error: Cannot find module 'express'
```

**Fix:** Install the dependencies:

```bash
npm install express mongoose cors dotenv
```

### 2. Docker Daemon Not Running

```bash
docker: error during connect: ... cannot find the file specified
```

**Fix:** Docker Desktop wasn’t running. Start it manually.

* [Docker Desktop Troubleshooting](https://docs.docker.com/desktop/troubleshoot/overview/)

### 3. Missing MongoDB URI

```bash
MongooseError: The `uri` parameter to `openUri()` must be a string, got "undefined"
```

**Fix:** You forgot to create a `.env` file or load it with `dotenv.config()`

* [dotenv package](https://www.npmjs.com/package/dotenv)

### 4. Axios 400 Error When Input Was Empty

```bash
Request failed with status code 400
```

**Cause:** You clicked “Add” with an empty input box

### Fix: Add Validation in Backend

In `POST /api/todos` route:

```js
if (!text || typeof text !== "string" || text.trim() === "") {
  return res.status(400).json({ message: "Task text is required." });
}
```

### Fix: Add Validation in Frontend

In `App.js`:

```js
if (!newTask.trim()) {
  setError("Please enter a task.");
  return;
}
```

Display error message below input:

```jsx
{error && <p style={{ color: "red" }}>{error}</p>}
```

---

## Axios Function Examples

### `addTodo()`

```js
axios.post(API_URL, { text: newTask })
```

**Input (to backend):** `{ text: "Buy eggs" }`
**Output (from backend):** `{ _id: "abc", text: "Buy eggs", isDone: false }`

* [Axios POST Docs](https://axios-http.com/docs/post_example)

### `toggleDone()`

```js
axios.put(`${API_URL}/${id}`, { isDone: !current })
```

**Input:** `{ isDone: true }`
**Output:** Updated todo object

* [Axios PUT Docs](https://axios-http.com/docs/req_config)

### `deleteTodo()`

```js
axios.delete(`${API_URL}/${id}`)
```

**Effect:** Removes it from the DB and filters it from UI state

* [Axios DELETE Docs](https://axios-http.com/docs/example)

---

## Summary

You:

* Built the full-stack to-do app
* Understood how MongoDB Docker container is used
* Debugged multiple real-world errors
* Implemented both backend and frontend validation

This `post-1-explanation.md` acts as your dev log, debugger, and learning journal.
