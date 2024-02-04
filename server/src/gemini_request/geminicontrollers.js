const Gemini=require('./geminiSchema');
const { GoogleGenerativeAI } = require("@google/generative-ai");
const genAI=new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const textRequest=async (req,res)=>{
    const {question,user_email}=req.body;
    if(question&&user_email){
      const answer= await geminiAPI(question);
    const  geminidb=new Gemini({user_email:user_email,question:question,answer:answer});
      geminidb.save().then((result)=>{
        res.status(200).send({answer:answer})
      }).catch((err)=>{res.status(500).send({message:"Something went Wrong. Try again Later"})})
      
    }
    else{
        res.status(400).send({message:"Invalid Question "})
    }

}




async function geminiAPI(question){
    const model=genAI.getGenerativeModel({model: "gemini-pro"})
    const geminiAnswer=await model.generateContent(question);
    const response=geminiAnswer.response;
    console.log(response.text());
    return response.text();
}

module.exports={textRequest}