const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');
const bcrypt = require('bcrypt');
const path = require('path');
const User = require('../models/user_model');
let db = require('../configs/db_connection');
const jwt = require('jsonwebtoken');



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
    const user = await User.findOne({
        userName: req.body.userName
    }, async(err, user) => {
        //console.log(user);
        if (err) {
            res.json(err)
        } else if (!user) {
            res.status(404).json({
                    "success": false,
                    "code": 404,
                    "message": "Verilen userName bilgileri hatalıdır."
                }) // e posta hatalı
        } else {
            bcrypt.compare(req.body.password, user.password, (error, result) => {
                //console.log(req.body.password + user.password);
                if (error) {
                    res.json(error)
                } else if (!result) {
                    res.status(404).json({
                            "success": false,
                            "code": 404,
                            "message": "Verilen password bilgileri hatalıdır.",
                        }) // şifre hatalı
                } else if (result) {
                    const token = jwt.sign({
                        id: user._id
                    }, 'supersecret', {
                        expiresIn: '24h'
                    })
                    res.status(200).json({
                        "success": true,
                        "code": 200,
                        "message": "Girişiniz başarıyla yapıldı.",
                        "data": {
                            profile: user,
                            token: token
                        }
                    })
                }

            })
        }
    })
}

const signUp = async(req, res) => {
    if (req.err) {
        console.log(req.err);
        if (req.err.details[0].type == 'any.required') {
            res.status(req.err.statusCode).json({
                success: false,
                code: 400,
                message: "Lütfen bütün alanları doldurun."
            })
        } else if (req.err.details[0].type == 'string.email') {
            res.status(req.err.statusCode).json({
                success: false,
                code: 400,
                message: "Lütfen geçerli bir email girin."
            })
        } else if (req.err.details[0].type == 'string.pattern.base') {
            res.status(req.err.statusCode).json({
                success: false,
                code: 400,
                message: "Lütfen geçerli bir telefon numarası girin."
            })
        }
    } else {
        try {
            var hashedPassword = await bcrypt.hash(req.body.password, 8);
            const user = User.create({
                userName: req.body.userName,
                name: req.body.name,
                lastName: req.body.lastName,
                email: req.body.email,
                password: hashedPassword,
                phoneNumber: req.body.phoneNumber,
            }, (err, user) => {
                if (err) {
                    if (err.code == 11000) {
                        res.status(409).json({
                            "success": false,
                            "code": 409,
                            "message": `Daha önceden bu ${Object.keys(err.keyPattern)[0]} ile kaydolunmuş.`,
                        })
                        console.log(err)
                    } else if (err) {
                        res.json(err)
                    }
                } else {
                    const token = jwt.sign({
                        id: user._id
                    }, 'supersecret', {
                        expiresIn: '24h'
                    })
                    res.status(200).json({
                        "success": true,
                        "code": 200,
                        "message": "Database'e ekleme yapıldı.",
                        "data": {
                            profile: user,
                            token: token
                        }
                    })
                }
            })
        } catch (err) {
            res.json(err)
        }
    }
}

const users = async(req, res) => {
    try {
        const result = await User.find()
            .select({ areas: 0, __v: 0 })
        res.status(200).json({
            "success": true,
            "code": 200,
            "message": "Kullanıcılar gönderildi.",
            "data": result
        })
    } catch (err) {
        console.log(err);
    }
}

const signUpDeneme = (req, res) => {
    res.render('signUp')
}
const signInDeneme = (req, res) => {
    res.render('signIn')
}
const signinwithgoogle = (req, res) => {
    // res.json(req.user)
    if (req.user) {
        res.json(req.user)
    } else {
        res.redirect('/')
    }
}

const updateUser = (req, res) => {
    try {
        const user = User.findOneAndUpdate({ _id: req.body._id }, { phoneNumber: req.body.phoneNumber, userName: req.body.userName }, { new: true }, (err, data) => {
            if (err) {
                res.json(err);
            } else {
                if (data !== null) {
                    res.status(200).json({
                        "success": true,
                        "code": 200,
                        "message": "Kullanıcı bilgileri eklendi.",
                        "data": {
                            profile: data,
                        }
                    })
                } else {
                    res.status(404).json({
                        "success": false,
                        "code": 404,
                        "message": "Kullanıcı bulunamadı."
                    })
                }

            }

        })
    } catch (err) {
        res.json(err)
    }
}

const followLink = (req, res) => {
    try {
        const user = User.findOneAndUpdate({ id: req.body.id }, { $push: { followedSites: req.body.site } }, { new: true }, (err, data) => {
            if (err) {
                res.json(err);
            } else {
                res.status(200).json({
                    "success": true,
                    "code": 200,
                    "message": "Site takip edildi.",
                    "data": {
                        profile: data,
                    }
                })
            }

        })
    } catch (err) {
        res.json(err)
    }
}

const unFollowLink = (req, res) => {
    try {
        const user = User.findOneAndUpdate({ id: req.body.id }, { $pull: { followedSites: { link: req.body.link } } }, { new: true }, (err, data) => {
            if (err) {
                res.json(err);
            } else {
                res.status(200).json({
                    "success": true,
                    "code": 200,
                    "message": "Takip edilen site silindi.",
                    "data": {
                        profile: data,
                    }
                })
            }

        })
    } catch (err) {
        res.json(err)
    }
}

module.exports = {
    scrapLink,
    signUp,
    signIn,
    users,
    signUpDeneme,
    signInDeneme,
    signinwithgoogle,
    followLink,
    unFollowLink,
    updateUser
};