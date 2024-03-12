const express=require('express');
const upload=require('../middleware/multer_image')
const geminiRouters=express.Router();
const geminiControllers=require('./geminicontrollers');
const authenticateJWT = require('../middleware/authenticateJWT');


geminiRouters.post('/textreq',authenticateJWT,geminiControllers.textRequest);
geminiRouters.post('/fileupload',authenticateJWT,upload,geminiControllers.fileUpload);
geminiRouters.get('/getallconvos',authenticateJWT,geminiControllers.getAllConversation);
geminiRouters.get('/getallqns',authenticateJWT,geminiControllers.getAllQuestions);

module.exports=geminiRouters;