const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = 4002;
const MONGO_URL = process.env.MONGO_URL || 'mongodb://localhost:27017/todosdb';

app.use(cors());
app.use(express.json());

// Mongoose model
const todoSchema = new mongoose.Schema({
  text: String,
  done: { type: Boolean, default: false }
});
const Todo = mongoose.model('Todo', todoSchema);

// Routes
app.get('/api/todos', async (req, res) => {
  const todos = await Todo.find();
  res.json(todos);
});

app.post('/api/todos', async (req, res) => {
  const todo = new Todo({ text: req.body.text });
  await todo.save();
  res.status(201).json(todo);
});

// Connect DB then start server
mongoose
  .connect(MONGO_URL)
  .then(() => {
    console.log('Connected to Mongo:', MONGO_URL);
    app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
  })
  .catch(err => {
    console.error('Mongo connection error', err);
    process.exit(1);
  });
