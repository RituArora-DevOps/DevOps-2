const mongoose = require("mongoose");

const TodoSchema = new mongoose.Schema({
  text: {
    type: String,
    required: true,
  },
  isDone: {
    type: Boolean,
    required: false,
  },
});

module.exports = mongoose.model("Todo", TodoSchema);
