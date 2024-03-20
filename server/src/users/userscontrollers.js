const User=require("./userSchema");
const bcrypt=require("bcrypt");
const jwt = require('jsonwebtoken');

const userSignUp=async (req,res)=>{
try{
        var {name,email,phoneNumber,password}=req.body;
        if(!name||!email||!phoneNumber||!password){return res.status(400).send({message:"Enter all Credentials"})}
       else{  console.log(name,email,phoneNumber,password);
       await bcrypt.hash(password,10).then((hash)=>{
            password=hash;
         })
         const user=new User({name,phoneNumber,email,password});
         user.save().then((result)=>{
            console.log("User Created");
         }).catch((err)=>{
            console.log(err);
            return  res.status(500).send({message:"Something went Wrong Try Again Later"})
        })
        return  res.status(200).send({message:"User Created"});
        }
    }
    catch(e){
        throw Error (e);
    }
}

const userSignIn=async (req,res)=>{
    const{email,password}=req.body;
try{
    if(!email,!password){
      return  res.status(400).send({message:"Enter all Credentials"})
    }
    else{
    const user=await User.findOne({email:email});
   if(!user){ return res.status(400).send({message:"User does not Exist"})}
else{
    const ispassword=  await bcrypt.compare(password, user.password);

    if(ispassword){
        let jwtSecretKey = process.env.JWT_SECRET_KEY;
        let data={name:user.name,email:user.email}
        const token=jwt.sign(data,jwtSecretKey,{expiresIn:'7d'});
        console.log(jwt.decode(token));
        return  res.status(200).send({token:token,message:"Login Successful"})}
    else{
        return res.status(400).send({message:"Incorrect Password"})
    }
}
    }
}
catch(e){
    console.log(e);
    return res.status(500).send({message:"Something wrong Try Again Later"})
}
}
const verifyToken=async (req,res)=>{
    const token=req.headers['authorization'];
    let jwtSecretKey = process.env.JWT_SECRET_KEY;
    console.log(token);
    if(token){
        jwt.verify(token,jwtSecretKey,function (err, decoded) {
            if (err) {
            let errordata = {
            message: err.message,
            expiredAt: err.expiredAt
            };
            console.log(errordata);
            return res.status(401).json({
            message: 'Unauthorized Access'
            });
            }
            req.decoded = decoded;
            console.log(decoded);
            res.status(200).send({message:"Access Granted"})
            });
            } else {
            return res.status(403).json({
            message: 'Forbidden Access'
            });
    }
}

module.exports={userSignUp,userSignIn,verifyToken};