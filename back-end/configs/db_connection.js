const path = require('path');
const sqlite3 = require('sqlite3').verbose();


// db.run('CREATE TABLE users(name text, lastName text, email text, password text, userName text, phoneNumber text, followingSites text)');

// db.run('drop TABLE users');

let db = new sqlite3.Database((path.resolve(__dirname, '../db/sample.db')), (err) => {
    if (err) {
        console.error("db'ye bağlanırken hata oluştu: " + err.message);
    } else console.log('Connected to the sample database.');
});

module.exports = db;