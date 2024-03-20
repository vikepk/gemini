const express=require('express');
const app=require('./src/config/mongodb')

const mongodb=require('./src/config/mongodb');
const User=require('./src/users/usersroutes');
const { json } = require('body-parser');
const userRouters = require('./src/users/usersroutes');
const geminiRouters=require('./src/gemini_request/geminiroutes');
// const geminicmd=require('./src/gemini/app');
app.use(express.json());
app.use('/uploads',express.static('uploads'));




app.get('/server_status',(req,res)=>res.send('<h1>SERVER UP</h1>'));


app.use('/api/v1/users',userRouters);
app.use('/api/v1/gemini',geminiRouters);
