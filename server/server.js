const express=require('express');
const mongodb=require('./src/config/mongodb');
const app=require('./src/config/mongodb')
const { json } = require('body-parser');
const userRouters = require('./src/users/usersroutes');
const geminiRouters=require('./src/gemini_request/geminiroutes');

// const geminicmd=require('./src/gemini/app');
//For Running Gemini in Cmd
app.use(express.json());
app.use('/uploads',express.static('uploads'));

app.get('/server_status',(req,res)=>res.send('<h1>SERVER UP</h1>'));

app.use('/api/v1/users',userRouters);
app.use('/api/v1/gemini',geminiRouters);


  