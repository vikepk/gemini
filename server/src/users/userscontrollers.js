const User=require("./userSchema");
const bcrypt=require("bcrypt");
const jwt = require('jsonwebtoken');

const userSignUp=async (req,res)=>{

        var {name,email,phoneNumber,password}=req.body;
        if(!name||!email||!phoneNumber||!password){res.status(404).send({message:"Enter all Credentials"})}
       else{  console.log(name,email,phoneNumber,password);
       await bcrypt.hash(password,10).then((hash)=>{
            password=hash;
         })
         const user=new User({name,phoneNumber,email,password});
         user.save().then((result)=>{
            console.log("User Created")
         }).catch((err)=>{console.log(err)})
         res.status(200).send("User Created");
        }
}

const userSignIn=async (req,res)=>{
    const{email,password}=req.body;

    if(!email,!password){res.status(404).send("Enter all Credentials")}
    const user=await User.findOne({email:email})
 
   if(!user){res.status(400).send("User does not Exist")}
else{
    const ispassword=  await bcrypt.compare(password, user.password);

    if(ispassword){
        let jwtSecretKey = process.env.JWT_SECRET_KEY;
        let data={name:user.name,email:user.email}
        const token=jwt.sign(data,jwtSecretKey);
        //console.log(jwt.decode(token))
        res.status(200).send({token:token})}
    else{
        res.status(400).send("Wrong Credentials")
    }
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
           
            });
            } else {
            return res.status(403).json({
            message: 'Forbidden Access'
            });
    }
}

module.exports={userSignUp,userSignIn,verifyToken};