const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const bcrypt = require('bcrypt');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

let db = require('../configs/db_connection');




const scrapLink = (req, res) => { //link formdan gelmeli, web scrap yapacak

    const url = 'https://blog.logrocket.com';
    const htmlFilePath = 'previous_page.html';

    function checkForNewContent(html) {
        const $ = cheerio.load(html);

        // Örnek: Blog yazılarının tarih bilgilerini al
        const postTimestamps = [];
        $('.post .timestamp').each((index, element) => {
            postTimestamps.push($(element).text());
        });

        // Önceki sayfa içeriğini kontrol et
        if (fs.existsSync(htmlFilePath)) {
            const previousHtml = fs.readFileSync(htmlFilePath, 'utf8');

            const previous$ = cheerio.load(previousHtml);
            const previousTimestamps = [];
            previous$('.post .timestamp').each((index, element) => {
                previousTimestamps.push(previous$(element).text());
            });

            // Yeni blog yazılarını tespit et
            const newPosts = postTimestamps.filter(timestamp => !previousTimestamps.includes(timestamp));
            if (newPosts.length > 0) {
                console.log('Yeni blog yazıları tespit edildi:');
                console.log(newPosts);
                // Yeni blog yazıları varsa gerekli işlemleri yapabilirsiniz.
            } else {
                console.log('Yeni blog yazısı bulunamadı.');
            }
        }

        // Güncel HTML içeriğini dosyaya kaydet
        fs.writeFileSync(htmlFilePath, html, 'utf8');
    }

    let checkNew = () => {
        axios.get(url)
            .then(response => {
                const html = response.data;
                checkForNewContent(html);
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
    }

    checkNew();

    let checkForNew = setInterval(checkNew, 60000); //dakikada bir sayfada yeni blog var mı kontrol ediyor.

}

const signIn = async(req, res) => {
    db.get('SELECT * FROM users WHERE userName = ?', [req.body.userName], (err, user) => {
        if (err) {
            return res.status(500).json({ error: 'Veritabanında bir hata oluştu.' + err });
        }
        if (!user) {
            return res.status(401).json({ error: 'Kullanıcı bulunamadı.' });
        }
        bcrypt.compare(req.body.password, user.password, (bcryptErr, result) => {
            if (bcryptErr) {
                return res.status(500).json({ error: 'Şifre karşılaştırma sırasında bir hata oluştu.' });
            }

            if (!result) {
                return res.status(401).json({ error: 'Şifre yanlış.' });
            }

            res.status(200).json({ message: 'Giriş başarılı.' });
        });
    })
}

const signUp = async(req, res) => {
    if (req.err) {
        console.log(req.err);
    } else {
        try {
            var hashedPassword = await bcrypt.hash(req.body.password, 8);
            let infos = [req.body.name, req.body.lastName, req.body.email, hashedPassword, req.body.userName, req.body.phoneNumber]
            db.run('INSERT INTO users(name, lastName, email, password, userName, phoneNumber) VALUES(?, ?, ?, ?, ?, ?)', infos, (err, rows) => {
                if (err) {
                    return res.status(500).json({ error: 'Veritabanında bir hata oluştu.' + err });
                } else {
                    res.status(200).json({ message: 'Kayıt başarılı.' });
                }
            })

        } catch (err) {
            res.json(err)
        }
    }
}

const users = (req, res) => {
    let arr = [];
    db.all('SELECT * FROM users', [], (err, rows) => {
        if (err) {
            throw err;
        }
        rows.forEach((row) => {
            console.log(row);
            arr.push(row);
        });
        res.status(200).json({ message: 'Kullanıcılar gönderildi.', data: arr });
    });
}


module.exports = {
    scrapLink,
    signUp,
    signIn,
    users
};