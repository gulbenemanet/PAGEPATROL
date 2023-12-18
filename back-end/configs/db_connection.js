require('dotenv').config()
const mongoose = require('mongoose')

mongoose.connect('mongodb+srv://gulbenemanet:Rq8CIzUdjV479AjE@pagepatrol.r1sqrqf.mongodb.net/', {
        useNewUrlParser: true,
        useCreateIndex: true,
        useFindAndModify: false,
        useUnifiedTopology: true
    })
    .then(() => console.log("DB'ye bağlanldı"))
    .catch(err => console.log("DB'ye bağlanırken hata oluştu: " + err))