const Gemini=require('./geminiSchema');
const { GoogleGenerativeAI } = require("@google/generative-ai");
const genAI=new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const fs=require('fs');
const User =require('../users/userSchema')

async function geminiAPI_text(question){
  const model=genAI.getGenerativeModel({model: "gemini-pro"})
  try{
  const geminiAnswer=await model.generateContent(question);
  const response=geminiAnswer.response;
  return response.text();
  }
    catch(e){
    console.log(e.toString());
    return e;
  
  }
}


async function geminiAPI_image(prompt,image){
  const model=genAI.getGenerativeModel({model: "gemini-1.5-flash"})
  try{
  const geminiAnswer=await model.generateContent([prompt,image])
  const response=geminiAnswer.response;
  return response.text();
  }
  catch(e){
  console.log(e);
  return e;
  }
}


const textRequest=async (req,res)=>{
    const {question,email}=req.body;
    if(!question||!email){
     return res.status(400).send({message:"Invalid Question"}); 
    }
    if(!await userExists(email)){
      return res.status(400).send({message:"User does not Exist"});
   }
    const answer= await geminiAPI_text(question);
    if (answer instanceof Error){
      console.log(Error);
      return res.status(500).send({message:"Try again later"});
    }
    const  geminidb=new Gemini({email:email,question:question,answer:answer});
      geminidb.save().then((result)=>{
        return res.status(200).send({answer:answer});
      }).catch((err)=>{
        console.log(err);
        return res.status(500).send({message:`Try Again Later`});
      });

}







const fileUpload =async (req,res)=>{
  if(req.fileValidationError) {
    return res.status(400).send({message:"Invalid Image Type"});
}
if(!req.file) {
  return res.status(400).send({message:"Image Required"});
}
const {prompt,email}=req.body;

if(!prompt||!email){
  return res.status(400).send({message:"Enter required Data"});
}
if(!await userExists(email)){
  return res.status(400).send({message:"User does not Exist"});
}
  const image={
    inlineData:{
      data: Buffer.from(fs.readFileSync(req.file.path)).toString("base64"),
      mimeType: req.file['mimetype'],
    }
  }

  const answer= await geminiAPI_image(prompt,image);

  if (answer instanceof Error) {
    console.log(Error.toString())
   return res.status(500).send({message:"Try Again Later"})
  }

const  geminidb=new Gemini({email:email,question:prompt,answer:answer,imgName:`${process.env.BASE_URL}/uploads/${req.file.filename}`});
geminidb.save().then((result)=>{
    return res.status(200).send({answer:answer})
  }).catch((err)=>{
    console.log(err);
    return res.status(500).send({message:"Something went Wrong. Try again Later"})});



}

const getAllConversation=async(req,res)=>{
  const {email}=req.body;
  if(!email){
    res.status(400).send({message:"Email Required"});
  }
  if(!await userExists(email)){
    return res.status(400).send({message:"User does not Exist"});
 }
    try{
  const allConvs=await Gemini.find({email:email});
  return res.status(200).send({conversation:allConvs})
  }
 catch(err){
  console.log(err);
  return res.status(500).send({message:"Try Again Later"})};
}




const getAllQuestions=async(req,res)=>{
  const{email}=req.body;
  if(!email){
    return res.status(400).send({message:"Email Required"});
  }
  if(!await userExists(email)){
     return res.status(400).send({message:"User does not Exist"});
  }
  try{
  const allQns=await Gemini.find({email:email}).select("question").sort({createdAt:-1});
  return res.status(200).send({conversation:allQns})
  }
 catch(err){
  console.log(err);
  return res.status(500).send({message:err.toString()})};
}

async function userExists(email){
    const user= await User.findOne({email:email})

    if(!user){
    return false;
  }
return true;

}


module.exports={textRequest,fileUpload,getAllConversation,getAllQuestions}