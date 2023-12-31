const bcrypt = require('bcrypt');
const path = require('path');
const User = require('../models/user_model');
let db = require('../configs/db_connection');
const jwt = require('jsonwebtoken');
const Token = require('../models/token_model');

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

const profile = async(req, res) => {
    try {

        res.status(200).json({
            "success": true,
            "code": 200,
            "message": "Kullanıcı bilgileri gönderildi.",
            "data": req.user
        })

    } catch (error) {
        res.json(error);
    }

}

const update_profile = async(req, res) => {
    try {
        const user = await User.findOneAndUpdate({ _id: req.body._id }, { name: req.body.name, lastName: req.body.lastName, email: req.body.email, phoneNumber: req.body.phoneNumber }, { new: true }, (err, data) => {
            if (err) {
                res.json(err);
            } else {
                res.json(data);
            }
        })
    } catch (error) {
        res.json(error)
    }
}


const usersSites = async(req, res) => {
    // console.log(req.user.followedSites);
    try {

        res.status(200).json({
            "success": true,
            "code": 200,
            "message": "Kullanıcının takip ettiği siteler gönderildi.",
            "data": req.user.followedSites
        })

    } catch (error) {
        res.json(error);
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

const updateLink = (req, res) => {
    try {
        const user = User.findOneAndUpdate({ _id: req.body.id, 'followedSites._id': req.body.siteId }, { $set: { 'followedSites.$.htmlPart': req.body.htmlPart } }, { new: true }, (err, data) => {
            if (err) {
                res.json(err);
            } else {
                res.status(200).json({
                    "success": true,
                    "code": 200,
                    "message": "Takipe başlandı.",
                    "data": {
                        data: data.followedSites,
                    }
                })
            }
        })
    } catch (error) {
        console.log(error);
    }
}

const followLink = (req, res) => {
    try {
        const user = User.findOneAndUpdate({ _id: req.body.id }, { $push: { followedSites: req.body.site } }, { new: true }, (err, data) => {
            // console.log(req.body.id);
            if (err) {
                res.json(err);
            } else {
                if (data == null) {
                    res.status(400).json({
                        "success": false,
                        "code": 400,
                        "message": "Kullanıcı bulunamadı.",
                    })
                } else {
                    const newFollowedSiteId = data.followedSites[data.followedSites.length - 1]._id;
                    // console.log("Yeni eklenen followedSite'nin ID'si:", newFollowedSiteId);
                    res.json(newFollowedSiteId);
                }
            }

        })
        console.log(user);
    } catch (err) {
        res.json(err)
    }
}

const unFollowLink = (req, res) => {
    try {
        console.log(req.body);

        const user = User.findOneAndUpdate({ _id: req.body.id }, { $pull: { followedSites: { _id: req.body.siteId } } }, { new: true }, (err, data) => {
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

const logOut = async(req, res) => {
    //res.json(req.headers.authorization);
    const headersToken = await req.headers.authorization;
    const token = Token.create({
        token: headersToken
    }, (err, docs) => {
        if (err) {
            res.json(err)
        } else {
            // console.log(docs);
            res.status(200).json({
                "success": true,
                "code": 200,
                "message": "Çıkış işlemi başarıyla yapıldı."
            })
        }
    })

}

const userId = async(req, res) => {
    res.json(req.user.id);
}

module.exports = {
    signUp,
    signIn,
    users,
    signUpDeneme,
    signInDeneme,
    signinwithgoogle,
    followLink,
    unFollowLink,
    updateUser,
    profile,
    logOut,
    userId,
    usersSites,
    updateLink,
    update_profile
};