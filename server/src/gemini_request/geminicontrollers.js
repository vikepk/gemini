const Gemini=require('./geminiSchema');
const { GoogleGenerativeAI } = require("@google/generative-ai");
const genAI=new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const fs=require('fs');
const path = require('path');

async function geminiAPI_text(question){
  const model=genAI.getGenerativeModel({model: "gemini-pro"})
  try{
  const geminiAnswer=await model.generateContent(question);
  const response=geminiAnswer.response;
  return response.text();
  }
    catch(e){
    console.log(e.toString());
  
  }
}


async function geminiAPI_image(prompt,image){
  const model=genAI.getGenerativeModel({model: "gemini-pro-vision"})
  try{
  const geminiAnswer=await model.generateContent([prompt,image])
  const response=geminiAnswer.response;
  return response.text();
  }
  catch(err){
  return err;
  }
}


const textRequest=async (req,res)=>{
    const {question,email}=req.body;
    if(question&&email){
      const answer= await geminiAPI_text(question);
    const  geminidb=new Gemini({email:email,question:question,answer:answer});
      geminidb.save().then((result)=>{
        res.status(200).send({answer:answer});
      }).catch((err)=>{res.status(500).send({message:`${err.toString()}`})})
      
    }
    else{
        res.status(400).send({message:"Invalid Question "})
    }

}







const fileUpload =async (req,res)=>{
  if(req.fileValidationError) {
    return res.status(400).send({message:"Invalid Image Type"});
}
if(!req.file) {
  return res.status(400).send({message:"Image Required"});
}
const {prompt,email}=req.body;

if(prompt&&email){
  console.log(req.file.path)
  const image={
    inlineData:{
      data: Buffer.from(fs.readFileSync(req.file.path)).toString("base64"),
      mimeType: req.file['mimetype'],
    }
  }
  const answer= await geminiAPI_image(prompt,image);

  if (answer instanceof Error) {
    res.status(500).send({err:"Gemimi Causes Error Try Again Later"})
  }
  else{
const  geminidb=new Gemini({email:email,question:prompt,answer:answer,imgName:`http://localhost:${3000}/uploads/${req.file.filename}`});
geminidb.save().then((result)=>{
    res.status(200).send({answer:answer})
  }).catch((err)=>{res.status(500).send({message:"Something went Wrong. Try again Later"})});
}
}
else{
  res.status(400).send({message:"Enter required Data"})
}
}

const getAllConversation=async(req,res)=>{
  const {email}=req.body;
  if(email){
    try{
  const allConvs=await Gemini.find({email:email});
  res.status(200).send({conversation:allConvs})
  }
 catch(err){res.status(500).send({message:err.toString()})};
}
else{
  res.status(400).send({message:"Email Required"})
}
}


const getAllQuestions=async(req,res)=>{
  const{email}=req.body;
  if(email){
    try{
  const allQns=await Gemini.find({email:email}).select("question").sort({createdAt:-1});
  res.status(200).send({conversation:allQns})
  }
 catch(err){res.status(500).send({message:err.toString()})};
}
else{
  res.status(400).send({message:"Email Required"})
}
}



module.exports={textRequest,fileUpload,getAllConversation,getAllQuestions}