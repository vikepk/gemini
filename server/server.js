const express=require('express');
const app=express();
const dotenv = require('dotenv');
const mongoose=require('mongoose');
const User=require('./src/users/usersroutes');
const { json } = require('body-parser');
const userRouters = require('./src/users/usersroutes');
const geminiRouters=require('./src/gemini_request/geminiroutes');
// const geminicmd=require('./src/gemini/app');
app.use(express.json());
app.use('/uploads',express.static('uploads'));
dotenv.config();

const dbURI='mongodb://localhost:27017/gemini';
mongoose.connect(dbURI).then((result)=>{
    app.listen(process.env.PORT);
console.log("Server listening....");
}).catch((err)=>console.log(err));
app.get('/',(req,res)=>res.send('<h1>SERVER UP</h1>'));


app.use('/api/v1/users',userRouters);
app.use('/api/v1/gemini',geminiRouters);
