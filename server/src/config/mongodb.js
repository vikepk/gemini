
const { MongoClient, ServerApiVersion } = require('mongodb');
const mongoose =require('mongoose');
const express=require('express');
const app=express();
const dotenv = require('dotenv');
dotenv.config();
const uri = process.env.DB_URI;
// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function run() {
  try {
    mongoose 
 .connect(process.env.DB_URI, {
        useNewUrlParser: true,
        })   
 .then(() => console.log("Database connected!"))
 .catch(err => console.log(err));
    // Connect the client to the server	(optional starting in v4.7)
    // await client.connect();
    // // Send a ping to confirm a successful connection
    // await client.db("gemini").command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");
    app.listen(process.env.PORT);
    console.log("Server listening....");
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);
module.exports=app;
