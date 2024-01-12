const User = require('../models/user_model');
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://localhost');
const axios = require('axios');
const mailer = require('nodemailer');


client.on("error", (err) => {
    console.log("MQTT bağlantısı kurulamadı: " + err);
})

client.on('connect', () => {
    console.log('Mosquitto ile bağlantı sağlandı');
});

let transporter = mailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.MAIL,
        pass: process.env.MAIL_PASSWORD
    }
});
const scrapLink = async(user) => {
    try {
        const followedSites = user.followedSites;

        for (let i = 0; i < followedSites.length; i++) {
            const site = followedSites[i];
            const url = site.link;

            try {
                const response = await axios.get(url);
                const newHtml = response.data;

                const previousSite = await User.findOne({ _id: user._id, 'followedSites._id': site._id }); // 

                if (previousSite) {
                    const previousHtml = previousSite.followedSites.find(s => s._id.equals(site._id)).htmlPart;
                    // console.log(previousHtml);
                    if (!newHtml.includes(previousHtml)) {
                        console.log(`${user.userName} kullanıcısından, Site: ${site.name} için yeni içerik tespit edildi.`);
                        const updatesUser = await User.updateOne({ _id: user._id, 'followedSites._id': site._id }, { $set: { 'followedSites.$.htmlPart': newHtml } }, { new: true })
                        if (updatesUser) {
                            console.log(`${user.userName} kullanıcısının siteleri güncellendi.`);

                            client.publish('notification', `Değişiklik tespit edildi. User Id:${user._id} Site Id: ${site._id} Site Linki: ${site.link}`);
                            if (user.notification.mail == true) {
                                transporter.verify(function(error, success) {
                                    if (error) throw error;
                                    else {
                                        console.log('Mail bağlantısı başarıyla sağlandı');
                                        let mailOptions = {
                                            from: process.env.MAIL,
                                            to: user.email,
                                            subject: 'Değişiklik algılandı.',
                                            text: site.name + "Adlı sitede değişiklik algılandı. Site Linki: " + site.link
                                        };
                                        transporter.sendMail(mailOptions, function(error, info) {
                                            if (error) {
                                                console.log(error);
                                            } else {
                                                console.log('Email sent: ' + user.userName + info.response);
                                            }
                                        });
                                    }
                                });
                            }
                        }
                        // client.publish('notification', `Değişiklik tespit edildi. User Id:${user._id} Site Id: ${site._id} Site Linki: ${site.link}`);
                    } else {
                        console.log(`${user.userName} kullanıcısından, Site: ${site.name} için yeni içerik tespit edilmedi.`);
                    }
                } else {
                    console.log(`${user.userName} kullanıcısından, Site: ${site.name} için önceki veri bulunamadı.`);
                }
            } catch (error) {
                console.error(`${user.userName} kullanıcısından, Site: ${site.name} için veri çekme hatası:`, error);
            }
        }
    } catch (error) {
        console.error('Hata:', error);
    }
};

const getUsers = async() => {
    try {
        const users = await User.find({});
        return users;
    } catch (error) {
        console.error('Kullanıcıları çekerken hata oluştu:', error);
        return [];
    }
};

// Her bir kullanıcı için dakikada bir
const runScrapLinkForUsers = async() => {
    const users = await getUsers();

    if (users.length > 0) {
        users.forEach(user => {
            setInterval(() => {
                scrapLink(user);
            }, 60000); // 60000 milisaniye = 1 dakika
        });
    } else {
        console.log('Kullanıcı bulunamadı.');
    }
};

runScrapLinkForUsers();
module.exports = {
    runScrapLinkForUsers
}