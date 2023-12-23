const express = require('express')
const app = express()
const cors = require('cors');
require('dotenv').config()
const path = require('path');
const passport = require('passport');
const session = require("express-session");
require('./middlewares/passport')
const ejs = require('ejs');
app.use(session({
    secret: "somesecret",
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false } // HTTPS kullanıyorsanız 'secure: true' yapın
}));

app.use(cors());
app.use(express.urlencoded({
    'extended': 'true'
}));
app.use(express.json());
// app.use(session({
//     maxAge: 1000 * 60 * 60 * 24 * 7, // 1 week
//     keys: ['deneme']
// }));
app.use(passport.initialize());
app.use(passport.session());
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');
app.use('/public', express.static(path.join(__dirname, 'public')));
require('./configs/db_connection');

app.listen(process.env.PORT, () => {
    console.log(`Example app listening on port ${process.env.PORT}`)
})

const routes = require('./routes/routes');
require('./configs/token_black_list_interval')

app.use('/', routes);