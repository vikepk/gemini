const express=require("express");
const usersControllers = require("./userscontrollers");
const userRouters=express.Router();
const authenticateJWT=require('../middleware/authenticateJWT');



userRouters.post('/signup',usersControllers.userSignUp);

userRouters.post('/signin',usersControllers.userSignIn);

userRouters.post('/verifytoken',authenticateJWT,usersControllers.verifyToken);
module.exports=userRouters;