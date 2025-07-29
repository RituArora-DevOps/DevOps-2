const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");

// Basic health check
router.get("/healthz", (req, res) => {
  res.status(200).send("Healthy");
});

// Startup check
router.get("/startupz", (req, res) => {
  res.status(200).send("Healthy");
});

// Liveness check to ensure app is still running
router.get("/livez", (req, res) => {
  res.status(200).send("Healthy");
});

// Readiness check to ensure database is ready to serve requests
router.get("/readyz", async (req, res) => {
  const isDbConnected = mongoose.connection.readyState === 1;

  if (!isDbConnected) {
    console.warn("Readiness failed: Mongoose not connected.");
    return res.status(503).send("Not ready");
  }
  try {
    await mongoose.connection.db.admin().ping();
    res.status(200).send("Ready");
  } catch (err) {
    console.error("Readiness failed: ", err.message);
    res.status(503).send("Not ready"); // Better than 500 for readiness probes as K8s expects 503
  }
});

module.exports = router;
