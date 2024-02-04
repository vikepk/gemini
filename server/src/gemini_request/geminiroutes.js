const express=require('express');

const geminiRouters=express.Router();

const geminiControllers=require('./geminicontrollers');
const authenticateJWT = require('../middleware/authenticateJWT');
geminiRouters.post('/api/v1/textreq',authenticateJWT,geminiControllers.textRequest);

module.exports=geminiRouters;