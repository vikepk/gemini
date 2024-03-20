const mongoose = require('mongoose');
const express = require('express');
const dotenv = require('dotenv');

const app = express();
dotenv.config();

const PORT = process.env.PORT || 3000;
const DB_URI = process.env.DB_URI;

async function run() {
  try {
    await mongoose.connect(DB_URI);
    console.log("Database connected");

    app.listen(PORT, () => {
      console.log(`Server listening on port ${PORT}`);
    });
  } catch (err) {
    console.error("Error connecting to the database:", err);
  }
}

run().catch(console.error);

module.exports = app;
