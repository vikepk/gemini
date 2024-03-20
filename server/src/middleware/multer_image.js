const multer=require('multer');
const moment=require('moment-timezone');
const path = require('path');
let allowedExtension = ['image/jpeg', 'image/webp', 'image/png','image/heic','image/heif'];
const fileFilter=(req,file,cb)=>{
if(allowedExtension.includes(file.mimetype)){
    cb(null,true);
}else{
    req.fileValidationError = 'Invalid Image Type';
    return cb(null, false, new Error('Invalid Image Type'));
    
}
}
const storage =multer.diskStorage({
destination:function(req,file,cb){
    cb(null, path.join(__dirname, '/uploads/'));
},
filename:function(req,file,cb){
    cb(null, `${moment().utcOffset("+05:30").valueOf().toString()}.${file.originalname.split(".").pop()}` );
    
}
})
const upload=multer({storage:storage,fileFilter:fileFilter,limits:{fileSize:1024*1024*4}});

module.exports=upload.single('image');