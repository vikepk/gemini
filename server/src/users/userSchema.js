const mongoose=require('mongoose');

const UserSchema=mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    phoneNumber:{
        type:String,
        required:true
    },
    email:{
        type:String,
        required:true,
        index:{unique:true}
    },
    password:{
        type:String,
        required:true
    },
    
},{timestamps:true});

const User=mongoose.model('users',UserSchema)

module.exports=User;