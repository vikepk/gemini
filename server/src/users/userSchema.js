const mongoose=require('mongoose');

const UserSchema=mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    phoneNumber:{
        type:Number,
        required:true
    },
    email:{
        type:String,
        required:true
    },
    password:{
        type:String,
        required:true
    },
    
},{timestamps:true});

const User=mongoose.model('users',UserSchema)

module.exports=User;