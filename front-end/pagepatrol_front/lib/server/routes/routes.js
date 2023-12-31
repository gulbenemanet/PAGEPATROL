const router = require('express').Router();
const apiController = require('../controllers/api_controller');
const scrapping = require('../controllers/scrap_controller');
const passport = require('passport');
const auth = require('../middlewares/auth');


router.get('/', (req, res) => { res.json("ok") });
// router.get('/scrapLink', auth, scrapping.scrapLink);
router.post('/signUp', apiController.signUp);
router.post('/signIn', apiController.signIn);
router.post('/updateUser', apiController.updateUser);
router.post('/followLink', apiController.followLink);
router.post('/unFollowLink', apiController.unFollowLink);
router.get('/users', apiController.users);
router.get('/usersSites', auth, apiController.usersSites);
router.get('/signUp', apiController.signUpDeneme)
router.get('/signIn', apiController.signInDeneme)
router.get('/profile', auth, apiController.profile)
router.get('/userId', auth, apiController.userId)
router.get('/logOut', auth, apiController.logOut)
router.post('/updateLink', apiController.updateLink)
router.put('/update_profile', apiController.update_profile)

router.get('/api/google', passport.authenticate('google', {
    scope: ['profile', 'email']
}))
router.get('/auth/google/callback', passport.authenticate('google', {
    failureRedirect: '/auth/error',
}), (req, res) => {
    res.redirect('/api/signinwithgoogle')
})
router.get('/api/signinwithgoogle', apiController.signinwithgoogle)


module.exports = router;