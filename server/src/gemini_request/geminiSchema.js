const mongoose=require('mongoose');

const GeminiSchema=mongoose.Schema({
    user_email:{
        type:String,
        required:true
    },
    question:{
        type:String,
        required:true
    },
    answer:{
        type:String,
        required:true
    }
},{timestamps:true});

const Gemini=mongoose.model('qn&an',GeminiSchema);

module.exports=Gemini;