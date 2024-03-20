const { GoogleGenerativeAI  , HarmCategory,
    HarmBlockThreshold,} = require("@google/generative-ai");

const readline = require('node:readline').createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal:false
});
const ora =require('ora');
const generationConfig = {
  temperature: 0.4,
  topK: 32,
  topP: 1,
  maxOutputTokens: 4096,
};

const safetySettings = [
  {
    category: HarmCategory.HARM_CATEGORY_HARASSMENT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
];
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
async function run() {
  
   console.log("GEMINI : Ask any Question ......\nType exit to close chat");
   try{
  const model = genAI.getGenerativeModel({ model: "gemini-pro"});
  // For text-only input, use the gemini-pro model
  while (true) {
    const userQuestion = await askUser("YOU: ");
    if (userQuestion.toLowerCase() === "exit") {
      console.log("Exiting chat...");
      break;
    }
const spinner=ora("Loading");
spinner.color='yellow'
spinner.start();
    const geminiAnswer = await model.generateContent(userQuestion,safetySettings,generationConfig);
    
    const response=await geminiAnswer.response;
   spinner.stop();
  
    console.log(`\nGEMINI: ${response.text()}`);
  }

  readline.close();
   
  }
   
    catch(e){
      console.log(e);
    }finally{
      readline.close();
    }
    
    function askUser(prompt) {
      return new Promise((resolve) => {
        readline.question(prompt, (answer) => {
          resolve(answer);
        });
      });
    }
  }
  
  module.exports=run();



