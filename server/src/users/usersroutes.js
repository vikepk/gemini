const express=require("express");
const usersControllers = require("./userscontrollers");
const userRouters=express.Router();
const authenticateJWT=require('../middleware/authenticateJWT');



userRouters.post("/api/v1/users/signup",usersControllers.userSignUp);

userRouters.post("/api/v1/users/signin",usersControllers.userSignIn);

userRouters.post("/api/v1/verifytoken",authenticateJWT,usersControllers.verifyToken);
module.exports=userRouters;