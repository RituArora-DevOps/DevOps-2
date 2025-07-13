const express = require("express");
// const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const todoRoutes = require("./routes/todos");
const connectDB = require("./db");
const healthRoutes = require("./routes/health");

const app = express();

// middleware
app.use(cors());
app.use(express.json());

// connect to MongoDB
connectDB();

app.use("/api/todos", todoRoutes);
app.use("/", healthRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
