const mongoose=require('mongoose');

const GeminiSchema=mongoose.Schema({
    email:{
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
    },
    imgName:{
        type:String,
        required:false
    }
},{timestamps:true});

const Gemini=mongoose.model('qn&an',GeminiSchema);

module.exports=Gemini;