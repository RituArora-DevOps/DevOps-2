const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    const connectionParams = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    };
    const useDBAuth = process.env.USE_DB_AUTH || false;
    if (useDBAuth) {
      connectionParams.user = process.env.MONGO_USERNAME;
      connectionParams.pass = process.env.MONGO_PASSWORD;
    }
    await mongoose.connect(process.env.MONGO_URI, connectionParams);
    console.log("Connected to database.");
  } catch (err) {
    console.error("MongodB connection error: ", err.message);
    process.exit(1);
  }
};

module.exports = connectDB;
