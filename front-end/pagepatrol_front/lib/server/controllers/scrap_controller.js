const User = require('../models/user_model');
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://localhost');
const axios = require('axios');

client.on("error", (err) => {
    console.log("MQTT bağlantısı kurulamadı: " + err);
})

client.on('connect', () => {
    console.log('Mosquitto ile bağlantı sağlandı');
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

                const previousSite = await User.findOneAndUpdate({ _id: user._id, 'followedSites._id': site._id }, { $set: { 'followedSites.$.htmlPart': newHtml } }, { new: true });

                if (previousSite) {
                    const previousHtml = previousSite.followedSites.find(s => s._id.equals(site._id)).htmlPart;

                    if (previousHtml !== newHtml) {
                        console.log(`${user.userName} kullanıcısından, Site: ${site.name} için yeni içerik tespit edildi.`);
                        client.publish('notification', `Değişiklik tespit edildi. User Id:${user._id} Site Id: ${site._id} Site Linki: ${site.link}`);
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

        console.log(`${user.userName} kullanıcısının siteleri güncellendi.`);
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

// runScrapLinkForUsers();
module.exports = {
    runScrapLinkForUsers
}