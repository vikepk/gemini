const User=require("./userSchema");
const bcrypt=require("bcrypt");
const jwt = require('jsonwebtoken');
const { options } = require("./usersroutes");

const userSignUp=async (req,res)=>{
try{
        var {name,email,phoneNumber,password}=req.body;
        if(!name||!email||!phoneNumber||!password){
            return res.status(400).send({message:"Enter all Credentials"});
        }
        if(await userExists(email)){
            return res.status(400).send({message:"User with same email Already Exist"});
         }
       await bcrypt.hash(password,10).then((hash)=>{
            password=hash;
         });
         const user=new User({name,phoneNumber,email,password});
         user.save().then((result)=>{
            console.log("User Created");
         }).catch((err)=>{
            console.log(err);
            return res.status(500).send({message:"Something went Wrong Try Again Later"});
        })
        return res.status(200).send({message:"User Created"});
        
    }
    catch(e){
        console.log(e);
        return res.status(500).send({message:"Something went Wrong Try Again Later"});
    }
}

const userSignIn=async (req,res)=>{
    const{email,password}=req.body;
try{
    if(!email||!password){
        return res.status(400).send({message:"Enter all Credentials"})
    }
   
    const user=await User.findOne({email:email})
 
   if(!user){
    return res.status(400).send({message:"User does not Exist"});
}

    const ispassword=  await bcrypt.compare(password, user.password);

    if(!ispassword){
        return res.status(400).send({message:"Incorrect Password"})
    }
    let jwtSecretKey = process.env.JWT_SECRET_KEY;
    let data={name:user.name,email:user.email};
    const token=jwt.sign(data,jwtSecretKey,{
        expiresIn: process.env.JWT_EXPIRES_IN,
      });
    return res.status(200).send({token:token,message:"Login Successful"});
}
       
catch(e){
    console.log(e);
    return res.status(500).send({message:"Something wrong Try Again Later"})
}
}
const verifyToken=async (req,res)=>{
    const token=req.headers['authorization'];
    let jwtSecretKey = process.env.JWT_SECRET_KEY;
    if(!token){
           return res.status(400).send({message:"Missing JWT Token"});
        }
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
            return res.status(200).send({message:"Access Granted"})
        });
} 
async function userExists(email){
    const user= await User.findOne({email:email})

    if(!user){
    return false;
  }
return true;

}


module.exports={userSignUp,userSignIn,verifyToken};