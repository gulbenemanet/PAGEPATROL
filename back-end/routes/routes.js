const router = require('express').Router();
const apiController = require('../controllers/api_controller');
const passport = require('passport');
const auth = require('../middlewares/auth');


router.get('/', (req, res) => { res.json("ok") });
router.get('/scrapLink', apiController.scrapLink);
router.post('/signUp', apiController.signUp);
router.post('/signIn', apiController.signIn);
router.post('/updateUser', apiController.updateUser);
router.post('/followLink', apiController.followLink);
router.post('/unFollowLink', apiController.unFollowLink);
router.get('/users', auth, apiController.users);
router.get('/signUp', apiController.signUpDeneme)
router.get('/signIn', apiController.signInDeneme)

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